tesseract item.png item -l item batch.nochop makebox
REM tesseract item.png item batch.nochop makebox
PAUSE
REM edit box file
tesseract item.png item nobatch box.train
unicharset_extractor item.box
REM make a font_prop.txt file
mftraining -F font_props.txt -U unicharset -O item.unicharset item.tr
cntraining item.tr
copy normproto item.normproto
copy Microfeat item.Microfeat
copy inttemp   item.inttemp
copy pffmtable item.pffmtable
combine_tessdata item.