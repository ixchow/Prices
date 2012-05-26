#include <Date.au3>
ConsoleWrite("X=" & MouseGetPos(0) & @CRLF)
ConsoleWrite("Y=" & MouseGetPos(1) & @CRLF)


;a = NowCalc()
;Sleep(4000)
;ConsoleWrite(_DateDiff('s', $a, _NowCalc())/60 & @CRLF)

;ConsoleWrite(_NowCalc() & @CRLF)
;ConsoleWrite(Number() & @CRLF)

$timeString = StringRegExpReplace(_NowCalc(), "[/ :]", "-")

;ConsoleWrite("C:\Users\Michael\Desktop\boxcutter-1.2\boxcutter.exe -c 1,1,1680,1050 "& $timeString &".bmp")


ConsoleWrite(StringRegExp(" ", "\A *\Z") & @CRLF)

