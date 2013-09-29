#include <ScreenCapture.au3>

Func MouseTo($box)
	; to troubleshoot boxes:
	;MouseMove($box[0], $box[1], 2)
	;Sleep(500)
	;MouseMove($box[0], $box[3], 2)
	;Sleep(500)
	;MouseMove($box[2], $box[1], 2)
	;Sleep(500)
	;MouseMove($box[2], $box[3], 2)
	;Sleep(500)
	MouseMove(Random($box[0], $box[2]), Random($box[1], $box[3]), 2)
EndFunc   ;==>MouseTo

Func Click($box)
	MouseTo($box)
	;Sleep(500)
	MouseClick("left")

EndFunc   ;==>Click

Func WriteValue($box, $val)
	Click($box)
	Sleep(Random(10, 20))
	Send("{BS}")
	Sleep(Random(10, 20))
	Send("{BS}")
	Sleep(Random(10, 20))
	Send("{BS}")
	Sleep(Random(10, 20))
	Send("{DEL}")
	Sleep(Random(10, 20))
	Send("{DEL}")
	Sleep(Random(10, 20))
	Send("{DEL}")
	Sleep(Random(10, 20))
	$split = StringSplit("" & $val, "")
	For $i = 1 To $split[0]
		Send($split[$i])
		Sleep(Random(10, 20))
	Next
EndFunc   ;==>WriteValue

Func ClickWait($box)
	;Move mouse away from search button:
	MouseMove(1, 1, 2)
	Sleep(50)
	Local $searchDoneSum = PixelChecksum($box[0], $box[1], $box[2], $box[3], 2)

	Click($box)
	MouseMove(1, 1, 2)

	;Wait for search to be done:
	;ConsoleWrite("Waiting for search to finish...");
	While 1
		Sleep(50)
		Local $searchSum = PixelChecksum($box[0], $box[1], $box[2], $box[3], 2)
		If $searchSum == $searchDoneSum Then
			ExitLoop
		Else
			;ConsoleWrite('.')
		EndIf
	WEnd
	;ConsoleWrite(" done." & @CRLF);
	EndFunc

Func Search()
	ClickWait($boxSearch)
EndFunc   ;==>Search

Func OCRBox($box, $arg, $filename="out")
	return OCR($box[0], $box[1], $box[2], $box[3], $arg, $filename)
EndFunc

Func OCR($x1, $y1, $x2, $y2, $arg, $filename="out")
	_ScreenCapture_Capture($filename & ".bmp", Int($x1), Int($y1), Int($x2), Int($y2), False)
	;RunWait(@ComSpec & " /c " & '"D:\Program Files (x86)\ImageMagick-6.8.6-Q16\convert" ' & $filename & ".bmp " & "-colorspace gray -negate -threshold 92% " & $filename & ".png ", "", @SW_HIDE)
	If Not StringCompare(@OSVersion , "Win_7") Then
	$command = @ComSpec & " /c " & '"D:\Program Files (x86)\Tesseract-OCR\tesseract" ' & $filename & ".bmp " & $filename & " " & $arg
	Else
	$command = @ComSpec & " /c " & '"C:\Program Files\Tesseract-OCR\tesseract" ' & $filename & ".bmp " & $filename & " " & $arg
	EndIf
	;ConsoleWrite($command & @LF)
	RunWait($command, "", @SW_HIDE)
	$s = FileRead($filename & ".txt")
	Return $s
EndFunc

Func BoxChecksum($box)
	Return PixelChecksum($box[0], $box[1], $box[2], $box[3], 2)
EndFunc
