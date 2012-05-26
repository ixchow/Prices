#include <screen_spots.au3>

HotKeySet("{ESC}", "Stop")
HotKeySet("{F2}", "Go")

While 1
    Sleep(100)
WEnd

Func Stop()
	Exit
EndFunc

Func MouseTo($box)
	MouseMove( Random($box[0], $box[2]), Random($box[1], $box[3]) )
EndFunc

Func Click($box)
	MouseTo($box)
	MouseClick("left")
EndFunc

Func WriteValue($box, $val)
	Click($box)
	Sleep(Random(50,70))
	Send("{BS}")
	Sleep(Random(50,70))
	Send("{BS}")
	Sleep(Random(50,70))
	Send("{BS}")
	Sleep(Random(50,70))
	Send("{DEL}")
	Sleep(Random(50,70))
	Send("{DEL}")
	Sleep(Random(50,70))
	Send("{DEL}")
	Sleep(Random(50,70))
	$split = StringSplit("" & $val, "")
	For $i = 1 To $split[0]
		Send($split[$i])
		ConsoleWrite($split[$i])
		Sleep(Random(50,70))
	Next
EndFunc

Func Go()
	ConsoleWrite("Script is running" & @CRLF)
	;WriteValue($boxLevelMin, "")
	;WriteValue($boxLevelMax, 15)
	;WriteValue($boxPref1Min, 1)
	;Click($boxSearch)
	MouseTo($boxSearch)
	Local $col = PixelGetColor($pixNextArrow[0], $pixNextArrow[1])
	$b = Mod($col, 256)
	$g = Mod(Int($col / 256), 256)
	$r = Mod(Int($col / 256 / 256), 256)
	ConsoleWrite("Color: " & Hex($col) & " or (" & $r & ", " & $g & ", " & $b & ")" & @CRLF)
;Have results -- Color: 00FCDB9E or (252, 219, 158)
;No results -- Color: 00948873 or (148, 136, 115)

	;For $i = 0 To 14
	;	MouseTo($boxItemSubtypeArrow)
	;	MouseClick("left")
	;	MouseTo($boxItemSubtypeScrollDown)
	;	MouseClick("left")
	;	Sleep(Random(100, 150))
	;	MouseClick("left")
	;	Sleep(Random(100, 150))
	;	MouseClick("left")
	;	Sleep(Random(100, 150))
	;	MouseTo($boxItemSubtype[$i])
	;	MouseClick("left")
	;	MouseTo($boxItemSubtypeName)
	;	MouseClick("left")
	;Next
	Exit
EndFunc
