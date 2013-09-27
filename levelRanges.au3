#include <screen_spots.au3>
#include <utils.au3>
#cs


#ce

; this script seems to find what properties are allowed at what level ranges

HotKeySet("{ESC}", "Stop")
HotKeySet("{F2}", "Go")

While 1
	Sleep(100)
WEnd


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

	ConsoleWrite("level" & @TAB & "value" & @CRLF)
	While 1
		WriteValue($boxPref1Min, $val)
		;Increase lev until there are results:
		While $lev < 61
			WriteValue($boxLevelMax, $lev)
			Search()
			Local $resultsSum = PixelChecksum($boxItem[0], $boxItem[1], $boxItem[2], $boxItem[3], 2)
			If Not ($resultsSum == $noResultsSum) Then
				ExitLoop
			EndIf
			$lev = $lev + 1
		WEnd
		If $lev == 61 Then
			ConsoleWrite("Ran out." & @CRLF)
			ExitLoop
		EndIf
		;Increase val until no more results:
		While 1
			$val = $val + 1
			WriteValue($boxPref1Min, $val)
			Search()
			Local $resultsSum = PixelChecksum($boxItem[0], $boxItem[1], $boxItem[2], $boxItem[3], 2)
			If $resultsSum == $noResultsSum Then
				$val = $val - 1
				ExitLoop
			EndIf
		WEnd
		ConsoleWrite($lev & @TAB & $val & @CRLF)
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
EndFunc   ;==>Go
