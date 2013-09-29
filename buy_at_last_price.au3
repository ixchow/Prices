#include <screen_spots.au3>
#include <utils.au3>

HotKeySet("{ESC}", "Stop")
HotKeySet("{F2}", "Go")

While 1
	Sleep(100)
WEnd

Func Stop()
	Exit
EndFunc   ;==>Stop

Func ReadPrice($box)
	$s = OCRBox($box, "-l price_yellow", "ppu")
	;ConsoleWrite($s & @LF)
	Local $amountStr = StringRegExp($s, "([0-9,]+) ?[*]", 1)
	If $amountStr == 0 Then
		Return -1
	EndIf
	Local $numChars = StringLen($amountStr[0])
	$s = StringLeft($s, $numChars)
	$s = StringRegExpReplace($s, ",", "")
	return Number($s)
EndFunc

Func Go()
	Click($tabCompleted)
	Sleep(500)
	$targetPrice = ReadPrice($boxCompletedAmount)
	ConsoleWrite("Target price is " & $targetPrice & @CRLF)

	While 1

		Click($tabSearch)
		Sleep(500)
		Click($boxCraftingBuyout)
		Click($boxCraftingBuyout)
		Click($boxCraftingBuyoutConfirm)

		; keep clicking OK until the screen isn't dim anymore (i.e."it works")
		Sleep(50)
		Local $checksum = BoxChecksum($checksumProcessingAuction)
			While 1
			Click($boxAuctionOK)
			Sleep(50)
			Local $curChecksum = BoxChecksum($checksumProcessingAuction)
			If NOT ($curChecksum == $checksum) Then
				ExitLoop
			Else

			EndIf
		WEnd

		Click($tabCompleted)
		Sleep(2000)

		ClickWait($boxSendToStash)
		Click($boxSendToStash)

		$curPrice = ReadPrice($boxCompletedAmount)
		ConsoleWrite("Bought at " & $curPrice)
		if $curPrice > $targetPrice Then
			ConsoleWrite( ", so stopping.")
			ExitLoop
		EndIf
		ConsoleWrite(@CRLF)
	WEnd
EndFunc
