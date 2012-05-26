#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>

Local $pagesDeep = 45
Local $numItems = 5000;

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Stop") ;script can be stopped by pressing -

Global $file = FileOpen("data.txt", 1)

Local $items[$numItems][8]
; 0:name, 1:dps, 2:bid, 3:buyout, 4:timeLeft, 5:startDate, 6:isActive, 7:newBid

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
	Next
EndIf


For $round = 1 To 3
	MouseClick("left", 430+ Random(-10, 10), 812+ Random(-2, 2)) ; search again
	Sleep(5000)
	For $page = 1 To $pagesDeep ;

	For $y = 292 To 742 Step 44
		$name = StringTrimRight(OCR(632, $y +5, 1067, $y + 40, "-l item -psm 7"), 2)
		If StringRegExp($name, "\A *\Z")==1 Then ; blank name
			ContinueLoop
		EndIF
		$dps = toNum(OCR(1040, $y+5, 1109, $y + 40, "-l d3 -psm 7"))
		$bid = toNumO(OCR(1109, $y+5, 1210, $y + 40, "-l d3 -psm 7"))
		$buyout = toNumO(OCR(1210, $y+5, 1310, $y + 40, "-l d3 -psm 7"))
		$timeLeft = StringTrimRight(OCR(1354, $y+5, 1419, $y + 40, "-l d3 -psm 7"), 2)


		If $bid == -1 OR $buyout == -1 Then
			ContinueLoop
		EndIf

		; find if the item exists
		Local $found  = False
		for $i = 0 To $numItems-1
			if $items[$i][6] And StringCompare($items[$i][0], $name)==0 AND $items[$i][3]==$buyout AND $items[$i][1]==$dps Then; match
				ConsoleWrite("got a match at " & $i & ", item name " & $name & @CRLF)
				$found = True
				If $items[$i][2] < $bid Then
					ConsoleWrite("** new bid at " & $i & ", item name " & $name & @CRLF)
					ConsoleWrite(@TAB & "from " & $items[$i][2] & " to " & $bid & @CRLF)
					$timeString = StringRegExpReplace(_NowCalc(), "[/ :]", "-")
					FileWriteLine($file, $timeString & @TAB & $name & @TAB & $dps & @TAB & $items[$i][2] & @TAB & $bid & @TAB & $buyout & @TAB & $timeLeft)
					MouseMove(609, $y+10)
					Sleep(1000)
					If Not $items[$i][7] Then
						RunWait("C:\Users\Michael\Desktop\boxcutter-1.2\boxcutter.exe -c 1,1,1680,1050 "& $timeString &".bmp")
					EndIf
					MouseMove(1600, $y+10)
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
					ConsoleWrite("added new item at " & $i & ", item name " & $name & @CRLF)
					$items[$i][0] = $name
					$items[$i][1] = $dps
					$items[$i][2] = $bid
					$items[$i][3] = $buyout
					$items[$i][4] = $timeLeft
					$items[$i][5] = _NowCalc()
					$items[$i][6] = True
					$items[$i][7] = False
					ExitLoop
					EndIf
			Next
		EndIf



	Next

; Remove old items
for $i = 0 To $numItems-1
	If _DateDiff('h', $items[$i][5], _NowCalc())  > 25 Then
		$items[$i][6] = False
		ConsoleWrite("removed old item at " & $i & ", item name " & $name & @CRLF)
	EndIf
Next
If $page <> $pagesDeep Then
	MouseClick("left", 1096 + Random(-2, 2), 799 + Random(-2, 2)) ; next page
	Sleep(100 + Random(100, 1000))
EndIf

Next
Next

Stop()



; Funcs

Func OCR($x1, $y1, $x2, $y2, $arg)
RunWait("C:\Users\Michael\Desktop\boxcutter-1.2\boxcutter.exe -c "&$x1&","&$y1&","&$x2&","&$y2&" out.bmp", "", @SW_HIDE)
Sleep(100)
RunWait("tesseract out.bmp out " & $arg, "", @SW_HIDE)
$s = FileRead("out.txt")
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
		For $j = 0 To 7
				FileWriteLine($dumpFile, $items[$i][$j])
		Next
	Next
	FileClose($dumpFile)
Exit
EndFunc

Func toNumO($x)
	$num = Number(StringRegExpReplace($x, '[, O]', ""))
	If StringRegExp($x, "[NA]") Then
		$num = 0
	ElseIf NOT StringRegExp($x, "O") Then
		$num = -1
	EndIf
	Return $num
EndFunc

Func toNum($x)
	$num = Number(StringRegExpReplace($x, '[ ]', ""))
	Return $num
EndFunc