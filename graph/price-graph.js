
var graphDirty = false;
var toGraph = [];

function updateGraph() {
	if (!graphDirty) return;
	graphDirty = false;

	var el = document.getElementById('chart');
	var canvasWidth = el.width;
	var canvasHeight = el.height;
	var ctx = el.getContext('2d');

	ctx.setTransform(1,0, 0,1, 0,0);
	ctx.fillStyle = "#eee";
	ctx.fillRect(0, 0, canvasWidth, canvasHeight);



	var max_time = 0;
	var min_time = (new Date()).getTime();
	var max_price = 1;
	for (var s = 0; s < toGraph.length; ++s) {
		var series = toGraph[s];
		for (var i = 0; i < series.vals.length; ++i) {
			var pair = series.vals[i];
			var time = pair[0];
			var price = pair[1];
			if (time < min_time) min_time = time;
			if (time > max_time) max_time = time;
			if (price > max_price) max_price = price;
		}
	}

	var OverviewFraction = 0.2;
	ctx.strokeStyle = "#000";
	for (var s = 0; s < toGraph.length; ++s) {
		var series = toGraph[s];
		ctx.beginPath();
		var first = true;
		for (var i = 0; i < series.vals.length; ++i) {
			var pair = series.vals[i];
			var time = pair[0];
			var price = pair[1];
			var x = (time - min_time) / (max_time - min_time);
			var y = price / max_price;
			x *= canvasWidth;
			y *= canvasHeight;
			if (first) {
				ctx.moveTo(x,y);
				first = false;
			} else {
				ctx.lineTo(x,y);
			}
			
		}
		ctx.stroke();
	}

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
	for (var i = 0; i < toGraph.length; ++i) {
		var series = toGraph[i];
		if (series.name == name) {
			if (series.vals.length != vals.length) {
				console.log("updating series '" + name + "'");
				series.updated = true;
				graphDirty = true;
			}
			series.vals = vals;
			found = true;
		}
	}
	if (!found) {
		console.log("adding series '" + name + "'");
		toGraph.push({
			name:name,
			vals:vals,
			updated:true
		});
		graphDirty = true;
	}
	window.requestAnimFrame(updateGraph);
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
}
