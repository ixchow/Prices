#include <screen_spots.au3>
#include <utils.au3>
#include <date.au3>

; Notes:
; Average of last 10 trades seems to update in real time and is not weighted on # units sold (did a test by buying 1 repeatedly)
; The shown PPU might not be what you actually pay, you will see the real amount in the 'completed' tab
;

; strings
Local $types[2] = ['crafting', 'dyes'];
Local $diffs[4] = ['normal', 'nightmare', 'hell', 'inferno'];
Local $dyeTypes[20] = ['summer', 'royal', 'all-soap', 'spring', 'mariner', 'winter', 'rangers', 'foresters', 'vanishing', 'cardinal', 'infernal', 'purity', 'autumn', 'desert', 'elegant', 'aquatic', 'abyssal', 'lovely', 'tanners', 'golden'];
Local $craftingTypes[3] = ['essence', 'monster', 'brimstone'];
Local $infoNames[2] = ['lastDay',  'last10'];

HotKeySet("{ESC}", "Stop")
HotKeySet("{F2}", "Go")


Local $infoBoxes[2] = [$boxCraftingLastDay, $boxCraftingLast10]
Local $outFile
While 1
	Sleep(100)
WEnd

Func Stop()
	FileClose($outFile)
	Exit
EndFunc   ;==>Stop

Func ReadAvg($box)
	$s = OCRBox($box, "-l price_yellow", "ppu")
	;ConsoleWrite($s & @LF)
	Local $amountStr = StringRegExp($s, "([0-9,]+) ?[*]? ?p", 1)
	If $amountStr == 0 Then
		Return -1
	EndIf
	Local $numChars = StringLen($amountStr[0])
	$s = StringLeft($s, $numChars)
	$s = StringRegExpReplace($s, ",", "")
	return Number($s)
EndFunc

Func TimeStamp($file)
	FileWrite($file, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & @TAB)
EndFunc


Func Go()
	While 1

	; scan the market

	; crafting
	Click($boxCraftingMenu0Arrow)
	Click($boxCraftingMenu0[0])
	WriteValue($boxCraftingQuantity, 1)
	For $diffInd = 0 To 3
		Click($boxCraftingMenu1Arrow)
		Click($boxCraftingMenu1[$diffInd])

		$numMats = 2
		If ($diffind == 3) Then
			$numMats = 3
		EndIf
		For $matInd = 0 To $numMats-1
			Click($boxCraftingMenu2Arrow)
			Click($boxCraftingMenu2[$matInd])


				Search()
				for $infoInd = 0 To UBound($infoNames)-1
					$curInfo = ReadAvg($infoBoxes[$infoInd])

					$outName = "commodity_out\" & $types[0] & "_" & $diffs[$diffInd] & "_" & $craftingTypes[$matInd] & "_" & $infoNames[$infoInd] & ".txt"
					$outFile = FileOpen($outName, 1)
					TimeStamp($outFile)
					FileWrite($outFile, $curInfo & @CRLF)
					FileClose($outFile)
				Next

				;Sleep(Random(10, 50))

		Next
	Next

	; dyes
	Click($boxCraftingMenu0Arrow)
	Click($boxCraftingMenu0[1])

	WriteValue($boxCraftingQuantity, 1)

	For $dyeInd = 0 To 19
		Click($boxCraftingMenu1Arrow)
		If $dyeInd == 0 Then ; make sure we're at the top of the scrolling dropdown
			For $clickInd = 0 To 8
				Click($boxCraftingMenu1ScrollUp)
			Next
			Click($boxCraftingMenu1[$dyeInd])
		ElseIf $dyeInd < 7 Then; menu auto scrolls
			Click($boxCraftingMenu1[1])
		ElseIf $dyeInd >= 7 Then
			Click($boxCraftingMenu1[$dyeInd-5])
		EndIf

		Search()
				for $infoInd = 0 To UBound($infoNames)-1
					$curInfo = ReadAvg($infoBoxes[$infoInd])

					$outName = "commodity_out\" & $types[1] & "_" & $dyeTypes[$dyeInd] & "_" & $infoNames[$infoInd] & ".txt"
					$outFile = FileOpen($outName, 1)
					TimeStamp($outFile)
					FileWrite($outFile, $curInfo & @CRLF)
					FileClose($outFile)
				Next

	Next

	FileWrite($outFile, @CRLF)
	Sleep(Random(5*60e3, 10*60e3))
	WEnd
EndFunc
