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
		Sleep(Random(50,70))
	Next
EndFunc

Func Search()
	;Move mouse away from search button:
	MouseTo($boxItemTypeArrow)
	Sleep(100)
	Local $searchDoneSum = PixelChecksum($boxSearch[0], $boxSearch[1], $boxSearch[2], $boxSearch[3], 2)

	Click($boxSearch)
	MouseTo($boxItemTypeArrow)

	;Wait for search to be done:
	;ConsoleWrite("Waiting for search to finish...");
	While 1
		Sleep(100)
		Local $searchSum = PixelChecksum($boxSearch[0], $boxSearch[1], $boxSearch[2], $boxSearch[3], 2)
		if $searchSum == $searchDoneSum Then
			ExitLoop
		Else
			;ConsoleWrite('.')
		EndIf
	WEnd
	;ConsoleWrite(" done." & @CRLF);
EndFunc

Func Go()
	ConsoleWrite("Script is running" & @CRLF)
	;Move mouse away from search button:

	;look for something with no results:
	WriteValue($boxLevelMin, "")
	WriteValue($boxLevelMax, 1)
	WriteValue($boxPref1Min, 999)

	Search()

	Local $noResultsSum = PixelChecksum($boxItem[0], $boxItem[1], $boxItem[2], $boxItem[3], 2)

	; Find first level with some amount:

	Local $lev = 1
	Local $val = 1

	ConsoleWrite("level, value" & @CRLF)
	While 1
		WriteValue($boxPref1Min, $val)
		;Increase lev until there are results:
		While $lev < 60
			WriteValue($boxLevelMax, $lev)
			Search()
			Local $resultsSum = PixelChecksum($boxItem[0], $boxItem[1], $boxItem[2], $boxItem[3], 2)
			if Not ($resultsSum == $noResultsSum) Then
				ExitLoop
			EndIf
			$lev = $lev + 1
		WEnd
		if $lev == 60 Then
			ConsoleWrite("Ran out." & @CRLF)
			ExitLoop
		EndIf
		;Increase val until no more results:
		While 1
			$val = $val + 1
			WriteValue($boxPref1Min, $val)
			Search()
			Local $resultsSum = PixelChecksum($boxItem[0], $boxItem[1], $boxItem[2], $boxItem[3], 2)
			if $resultsSum == $noResultsSum Then
				$val = $val - 1
				ExitLoop
			EndIf
		WEnd
		ConsoleWrite($lev & ", " & $val & @CRLF)
		$val = $val + 1 ;move to next-largest value
	WEnd


;	Local $col = PixelGetColor($pixNextArrow[0], $pixNextArrow[1])
;	$b = Mod($col, 256)
;	$g = Mod(Int($col / 256), 256)
;	$r = Mod(Int($col / 256 / 256), 256)
;	ConsoleWrite("Color: " & Hex($col) & " or (" & $r & ", " & $g & ", " & $b & ")" & @CRLF)
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