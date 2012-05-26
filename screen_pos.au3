#include <Date.au3>
#include <Array.au3>

;
; Quick hack to record a bunch of screen rectangles.
; Press 'space' after each corner
;

HotKeySet("{SPACE}", "RecordBox")
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Stop") ;script can be stopped by pressing -

Global $Paused = False
Global $corner[1]

Global $names[1]

_ArrayPush($names, "$boxSearch")
_ArrayAdd($names, "$boxNext")
_ArrayAdd($names, "$boxItem")
_ArrayAdd($names, "$boxDps")
_ArrayAdd($names, "$boxBid")
_ArrayAdd($names, "$boxBuyout")
_ArrayAdd($names, "$boxTimeLeft")

ConsoleWrite($names[0] & ' = ParseBox("')
_ArrayDelete($names, 0)

While 1
    Sleep(100)
WEnd

Func RecordBox()
	If UBound($corner) == 1 Then
		$corner[0] = MouseGetPos(0)
		_ArrayAdd($corner, MouseGetPos(1))
		ConsoleWrite("X=" & $corner[0] & " Y=" & $corner[1])
	Else
		_ArrayAdd($corner, MouseGetPos(0))
		_ArrayAdd($corner, MouseGetPos(1))
		ConsoleWrite(" X=" & $corner[2] & " Y=" & $corner[3] & '")' & @CRLF)
		ReDim $corner[1]

		If UBound($names) == 0 Then
			Exit
		EndIf

		ConsoleWrite($names[0] & ' = ParseBox("')
		_ArrayDelete($names, 0)
	EndIf

EndFunc

Func TogglePause()
$Paused = not $Paused
While $Paused
sleep(100)
WEnd
EndFunc

Func Stop() ;to allow the script to stop
	Exit
EndFunc