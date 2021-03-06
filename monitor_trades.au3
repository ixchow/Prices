#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <ScreenCapture.au3>
#include "./screen_spots.au3"

; tries to monitor weapon trades
; jimike 2012?

Func ClickWait($box)
	;Move mouse away from search button:
	MouseTo($boxItemTypeArrow)
	Sleep(50)
	Local $searchDoneSum = PixelChecksum($box[0], $box[1], $box[2], $box[3], 2)

	Click($box)
	MouseTo($boxItemTypeArrow)

	;Wait for search to be done:
	;ConsoleWrite("Waiting for search to finish...");
	While 1
		Sleep(50)
		Local $searchSum = PixelChecksum($box[0], $box[1], $box[2], $box[3], 2)
		if $searchSum == $searchDoneSum Then
			ExitLoop
		Else
			;ConsoleWrite('.')
		EndIf
	WEnd
	;ConsoleWrite(" done." & @CRLF);
EndFunc

Func MouseTo($box)
	MouseMove( Random($box[0], $box[2]), Random($box[1], $box[3]), 2 )
EndFunc

Func Click($box)
	MouseTo($box)
	MouseClick("left")
EndFunc

Local $pagesDeep = 45
Local $numItems = 5000;

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Stop") ;script can be stopped by pressing -

Global $file = FileOpen("data.txt", 1)

Local $items[$numItems][10]
; 0:name, 1:dps, 2:bid, 3:buyout, 4:timeLeft, 5:startDate, 6:isActive, 7:newBid, 8:isBad, 9:newThisRound

$dumpFile = FileOpen("dump.txt", 0)
If $dumpFile <> -1 Then
	ConsoleWrite("reading old dump file" & @CRLF)
		For $i = 0 To $numItems-1
			$items[$i][0] = FileReadLine($dumpFile)
			$items[$i][1] = Number(FileReadLine($dumpFile))
			$items[$i][2] = Number(FileReadLine($dumpFile))
			$items[$i][3] = Number(FileReadLine($dumpFile))
			$items[$i][4] = FileReadLine($dumpFile)
			$items[$i][5] = FileReadLine($dumpFile)
			$items[$i][6] = StringCompare(FileReadLine($dumpFile),"True") == 0
			$items[$i][7] = StringCompare(FileReadLine($dumpFile),"True") == 0
			$items[$i][8] = StringCompare(FileReadLine($dumpFile),"True") == 0
			$items[$i][9] = StringCompare(FileReadLine($dumpFile),"True") == 0
	Next
EndIf


For $round = 1 To 1
	ClickWait($boxSearch)
	For $page = 1 To $pagesDeep ;
	For $rowInd = 1 To 11;$y = 292 To 742 Step 44
		$y = Round($boxItem[1] + $lengthItemRowHeight * ($rowInd-1))
		MouseMove($boxTimeLeft[2]+20, $y, 2)
		$name = StringTrimRight(OCR($boxItem[0], $y +10, $boxItem[2], $y + 38, "-l item -psm 7", "ocr_name"), 2)
		If StringRegExp($name, "\A *\Z")==1 Then ; blank name
			ConsoleWrite("empty name, continuing" & @CRLF)
			ContinueLoop
		EndIF
		$dps = toNum(OCR($boxDps[0], $y+10, $boxDps[2], $y + 38, "-l d3 -psm 7", "ocr_dps"))
		$bid = bidToNum(OCR($boxBid[0], $y+10, $boxBid[2], $y + 38, "-l d3 -psm 7", "ocr_bid"))
		$buyout = buyoutToNum(OCR($boxBuyout[0], $y+10, $boxBuyout[2], $y + 38, "-l d3 -psm 7", "ocr_buyout"))
		$timeLeft = StringTrimRight(OCR($boxTimeLeft[0], $y+10, $boxTimeLeft[2], $y + 38, "-l d3 -psm 7"), 2)


		If $dps == -1 OR $bid == -1 OR ($bid > 0 AND $bid < 100) OR ($bid <> 0 And $buyout == -1 )  Then
			ConsoleWrite("bad read, continuing" & @CRLF)
			ContinueLoop
		EndIf


		; find if the item exists
		Local $found  = False
		for $i = 0 To $numItems-1
			if $items[$i][6] And StringCompare($items[$i][0], $name)==0 AND $items[$i][3]==$buyout AND $items[$i][1]==$dps Then; match
				;ConsoleWrite("got a match at " & $i & ", item name " & $name & @CRLF)
				$found = True
				If $items[$i][9] Then
					$items[$i][8] = True
					ConsoleWrite("got a duplicate at " & $i & ", item name " & $name & @CRLF)
					ExitLoop
				EndIf
				If $items[$i][2] < $bid OR ($items[$i][2] > 0 AND $bid == 0) AND (NOT $items[$i][8] )Then ; new bid coming in
					if $bid == 0 Then; "sold" case
						$bid = $items[$i][3]
					EndIf
					ConsoleWrite("** new bid at " & $i & ", item name " & $name & @CRLF)
					ConsoleWrite(@TAB & "from " & $items[$i][2] & " to " & $bid & @CRLF)
					$timeString = StringRegExpReplace($items[$i][5] & "_" & $name, "[/ :]", "-")
					FileWriteLine($file, $timeString & @TAB & $dps & @TAB & $items[$i][2] & @TAB & $bid & @TAB & $buyout & @TAB & $timeLeft)
					MouseMove($boxItem[0]- 10, $y+25)
					Sleep(1000)
					If Not $items[$i][7] Then
						RunWait("C:\Users\Michael\Desktop\boxcutter-1.2\boxcutter.exe -c 1,1,1680,1050 "& $timeString & "_" & $items[$i][2] & "_" & $bid &".bmp")
					EndIf
					MouseMove(@DesktopWidth, $y+20)
					$items[$i][2] = $bid
					$items[$i][7] = True
				EndIf
				ExitLoop
			EndIf
		Next

		; add new item
		If Not $found Then
			for $i = 0 To $numItems-1
				if Not $items[$i][6] Then
					ConsoleWrite("added: " & $name & @TAB & $bid & @CRLF)

					$items[$i][0] = $name
					$items[$i][1] = $dps
					$items[$i][2] = $bid
					$items[$i][3] = $buyout
					$items[$i][4] = $timeLeft
					$items[$i][5] = _NowCalc()
					$items[$i][6] = True
					$items[$i][7] = False
					$items[$i][8] = False
					$items[$i][9] = True
					ExitLoop
					EndIf
			Next
		EndIf
	Next

; reset the 'added this round' flag
For $i = 0 To $numItems-1
	$items[$i][9] = False
Next

; Remove old items
for $i = 0 To $numItems-1
	If _DateDiff('h', $items[$i][5], _NowCalc()) AND $items[$i][6]  > 25 Then
		$items[$i][6] = False
		ConsoleWrite("removed old item at " & $i & ", item name " & $name & @CRLF)
	EndIf
Next
If $page <> $pagesDeep Then ; next page
	 ClickWait($boxNext); next page
EndIf

Next
Next

Stop()



; Funcs

Func ClickBox($box)
	MouseClick("left", Random($box[0], $box[2]), Random($box[1], $box[3]))
EndFunc

Func OCR($x1, $y1, $x2, $y2, $arg, $filename="out")
	;ConsoleWrite("OCR-ing " & $x1 & " " & $y1 & " " & $x2 & " " & $y2 & @CRLF);
	_ScreenCapture_Capture($filename & ".bmp", Int($x1), Int($y1), Int($x2), Int($y2), False)
	;RunWait("C:\Users\Michael\Desktop\boxcutter-1.2\boxcutter.exe -c "&$x1&","&$y1&","&$x2&","&$y2&" out.bmp", "", @SW_HIDE)
	;Sleep(100)
	RunWait("tesseract " & $filename & ".bmp " & $filename & " " & $arg, "", @SW_HIDE)
	$s = FileRead($filename & ".txt")
	Return $s
EndFunc

Func Trim($s, $delim)
	$sAr = StringSplit($s,$delim)
	Return $sAr[1]
EndFunc

Func TogglePause()
$Paused = not $Paused
While $Paused
sleep(100)
WEnd
EndFunc

Func Stop() ;to allow the script to stop
	FileClose($file)
	$dumpFile = FileOpen("dump.txt", 2)
	For $i = 0 To $numItems-1
		For $j = 0 To 9
				FileWriteLine($dumpFile, $items[$i][$j])
		Next
	Next
	FileClose($dumpFile)
Exit
EndFunc

Func bidToNum($x)
	If StringRegExp($x, "S[oO]ld") Then
		$num = 0
	ElseIf NOT StringRegExp($x, "O") Then
		$num = Number(StringRegExpReplace($x, '[, ]', ""))
		$num = $num/10;
	Else
		$s = StringRegExpReplace($x, '[, O]', "")
		If StringRegExp($s, "[a-zA-Z]") Then
			$num = -1
		Else
			$num = Number($s)
		EndIf
	EndIf
	Return $num
EndFunc

Func buyoutToNum($x)
	If StringRegExp($x, "[NA]") Then
		$num = 0
	ElseIf NOT StringRegExp($x, "O") Then
		$num = Number(StringRegExpReplace($x, '[, ]', ""))
		$num = $num/10;
	Else
		$s = StringRegExpReplace($x, '[, O]', "")
		If StringRegExp($s, "[a-zA-Z]") Then
			$num = -1
		Else
			$num = Number($s)
		EndIf
	EndIf
	Return $num
EndFunc

Func toNum($x)
	If StringRegExp($x, "[a-zA-Z]") Then
		$num = -1
	Else
		$num = Number(StringRegExpReplace($x, '[ ]', ""))
	EndIf

	Return $num
EndFunc