tesseract d3.png d3 -l d3 batch.nochop makebox
REM tesseract d3.png d3 batch.nochop makebox
PAUSE
REM edit box file
tesseract d3.png d3 nobatch box.train
unicharset_extractor d3.box
REM make a font_prop.txt file
mftraining -F font_props.txt -U unicharset -O d3.unicharset d3.tr
cntraining d3.tr
copy normproto d3.normproto
copy Microfeat d3.Microfeat
copy inttemp   d3.inttemp
copy pffmtable d3.pffmtable
combine_tessdata d3.