

var OVERVIEW_HEIGHT = 60;
var graph = {
	dirty:false,
	data:[],
	minTime:0,
	maxTime:1,
	minVal:0,
	maxVal:1,
	viewLength:24 * 60 * 60 * 1000,
	viewMaxTime:0,
	queueUpdate:function() {
		if (!this.dirty) {
			this.dirty = true;
			window.requestAnimFrame(updateGraph);
		}
	},
	updateRange:function() {
		this.minTime = 0;
		this.maxTime = 1;
		this.minVal = 0;
		this.maxVal = 1;
		var first = true;
		for (var s = 0; s < graph.data.length; ++s) {
			var series = graph.data[s];
			series.minTime = 0;
			series.maxTime = 1;
			series.minVal = 0;
			series.maxVal = 1;
			for (var i = 0; i < series.vals.length; ++i) {
				var pair = series.vals[i];
				var time = pair[0];
				var val = pair[1];
				if (first) {
					this.minTime = time;
					this.maxTime = time;
					this.minVal = val;
					this.maxVal = val;
					series.minTime = time;
					series.maxTime = time;
					series.minVal = val;
					series.maxVal = val;
					first = false;
				}
				this.minTime = Math.min(this.minTime, time);
				this.maxTime = Math.max(this.maxTime, time);
				this.minVal = Math.min(this.minVal, val);
				this.maxVal = Math.max(this.maxVal, val);
				series.minTime = Math.min(series.minTime, time);
				series.maxTime = Math.max(series.maxTime, time);
				series.minVal = Math.min(series.minVal, val);
				series.maxVal = Math.max(series.maxVal, val);
			}
		}
		this.viewMaxTime = this.maxTime;
	},
	/* updateTime:function() {
		var newViewMaxTime = Math.floor((new Date()).getTime() / 1000) * 1000;
		if (this.viewMaxTime != newViewMaxTime) {
			this.viewMaxTime = newViewMaxTime;
			this.queueUpdate();
		}
		window.requestAnimFrame(function() { graph.updateTime(); } );
	}, */
	draw:function(el) {
		var canvasWidth = el.width;
		var canvasHeight = el.height;
		var ctx = el.getContext('2d');

		ctx.setTransform(1,0, 0,1, 0,0);
		ctx.fillStyle = "#eee";
		ctx.fillRect(0, 0, canvasWidth, canvasHeight);

		ctx.fillStyle = "#ccc";
		ctx.fillRect(0, canvasHeight - OVERVIEW_HEIGHT, canvasWidth, OVERVIEW_HEIGHT);
		viewMaxTime = this.viewMaxTime;
		viewMinTime = viewMaxTime - this.viewLength;

		ctx.fillStyle = "#fff";
		ctx.fillRect((viewMinTime - this.minTime) / (this.maxTime - this.minTime) * canvasWidth, canvasHeight - OVERVIEW_HEIGHT, (viewMaxTime - viewMinTime) / (this.maxTime - this.minTime) * canvasWidth, OVERVIEW_HEIGHT);

		//Draw overview:
		ctx.strokeStyle = "#000";
		for (var s = 0; s < this.data.length; ++s) {
			var series = this.data[s];
			ctx.beginPath();
			var prev = [];
			for (var i = 0; i < series.vals.length; ++i) {
				var pair = series.vals[i];
				var time = pair[0];
				var val = pair[1];
				if (val < 0) {
					if (prev.length) {
						ctx.stroke();
						ctx.beginPath();
						ctx.moveTo(prev[0]-2, prev[1]-2);
						ctx.lineTo(prev[0]+2, prev[1]+2);
						ctx.moveTo(prev[0]-2, prev[1]+2);
						ctx.lineTo(prev[0]+2, prev[1]-2);
						ctx.stroke();
						ctx.beginPath();
						prev = [];
					}
					continue;
				}
				var x = (time - this.minTime) / (this.maxTime - this.minTime) * canvasWidth;
				var y = canvasHeight - OVERVIEW_HEIGHT * val / series.maxVal;
				if (!prev.length) {
					ctx.moveTo(x,y);
					first = false;
				} else {
					ctx.lineTo(x,y);
				}
				prev = [x,y];
			}
			ctx.stroke();
		}


		//Draw focued range:
		ctx.strokeStyle = "#000";
		prev = [];
		for (var s = 0; s < this.data.length; ++s) {
			var series = this.data[s];
			ctx.beginPath();
			var prev = [];
			for (var i = 0; i < series.vals.length; ++i) {
				var pair = series.vals[i];
				var time = pair[0];
				var val = pair[1];
				if (time < viewMinTime) {
					continue;
				}
				if (val < 0) {
					if (prev.length) {
						ctx.stroke();
						ctx.beginPath();
						ctx.moveTo(prev[0]-4, prev[1]-4);
						ctx.lineTo(prev[0]+4, prev[1]+4);
						ctx.moveTo(prev[0]-4, prev[1]+4);
						ctx.lineTo(prev[0]+4, prev[1]-4);
						ctx.stroke();
						ctx.beginPath();
						prev = [];
					}
					continue;
				}
				var x = (time - viewMinTime) / (viewMaxTime - viewMinTime) * canvasWidth;
				var y = canvasHeight - (canvasHeight - OVERVIEW_HEIGHT) * val / series.maxVal;
				if (!prev.length) {
					ctx.moveTo(x,y);
					first = false;
				} else {
					ctx.lineTo(x,y);
				}
				prev = [x,y];
			}
			ctx.stroke();
		}



	}
};

function updateGraph() {

	var el = document.getElementById('chart');

	if (el.width != el.clientWidth
	 || el.height != el.clientHeight) {
		el.width = el.clientWidth;
		el.height = el.clientHeight;
		graphDirty = true;
	}

	if (!graph.dirty) return;
	graph.dirty = false;

	graph.updateRange();
	graph.draw(el);

}

function gotData(name, rawData) {
	var lines = rawData.split(/[\r\n]+/);
	var vals = [];
	for (var i = 0; i < lines.length; ++i) {
		var line = lines[i];
		var cols = line.split('\t');
		var date = new Date(cols[0]);
		var price = parseInt(cols[1]);
		if (!isNaN(price)) {
			vals.push([date.getTime(), price]);
		}
	}
	var found = false;
	for (var i = 0; i < graph.data.length; ++i) {
		var series = graph.data[i];
		if (series.name == name) {
			if (series.vals.length != vals.length) {
				console.log("updating series '" + name + "'");
				series.updated = true;
				graph.queueUpdate();
			}
			series.vals = vals;
			found = true;
		}
	}
	if (!found) {
		console.log("adding series '" + name + "'");
		graph.data.push({
			name:name,
			vals:vals,
			updated:true
		});
		graph.queueUpdate();
	}
}

function readFile(file) {
	var reader = new FileReader;
	reader.onloadend = function(){
		if (reader.result) {
			gotData(file.name, reader.result);
		}
	};
	reader.readAsText(file);
}

function pollFiles() {
	var fileList = document.getElementById('files').files;
	for (var i = 0; i < fileList.length; ++i) {
		var file = fileList[i];
		readFile(file);
	}
	if ('timeoutID' in pollFiles) {
		window.clearTimeout(pollFiles.timeoutID);
	}
	pollFiles.timeoutID = window.setTimeout(pollFiles, 5000);
}

function setup() {
	document.getElementById('files').addEventListener('change', function (e){
		pollFiles();
	}, false);
	window.requestAnimFrame =
		window.requestAnimationFrame
		|| window.webkitRequestAnimationFrame
		|| window.mozRequestAnimationFrame
		|| window.oRequestAnimationFrame
		|| window.msRequestAnimationFrame
		|| function(callback) {
          window.setTimeout(callback, 1000 / 60);
        };
	window.requestAnimFrame(updateGraph);
	//window.requestAnimFrame(function() { graph.updateTime(); } );
	window.onresize = function() {
		window.requestAnimFrame(updateGraph);
	};
}
