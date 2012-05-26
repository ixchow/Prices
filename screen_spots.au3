Local $boxSearch[4]
$boxSearch[0] = 430
$boxSearch[1] = 812
$boxSearch[2] = 433
$boxSearch[3] = 814

Local $boxNext[4]
$boxNext[0] = 1096
$boxNext[1] = 799
$boxNext[2] = 1097
$boxNext[3] = 800

; lengths
Local $boxItem= ParseBox("X=627 Y=297 X=1067 Y=771")

Local $boxDps = ParseBox("X=1040 Y=297 X=1109 Y=769")

Local $boxBid = ParseBox("X=1109 Y=297 X=1210 Y=769")

Local $boxBuyout = ParseBox("X=1210 Y=297 X=1310 Y=769")

Local $boxTimeLeft = ParseBox("X=1354 Y=297 X=1419 Y=769")

Local $locationBuyoutCol[2]


Local $locationTimeLeftCol[2]

; lengths
Local $lengthItemRowHeight = ($boxItem[3]-$boxItem[1])/11

Func ParseBox($s)
       Local $res = StringRegExp($s, 'X=(\d+) Y=(\d+) X=(\d+) Y=(\d+)', 1)
       Local $box[4]
       $box[0] = Int($res[0])
       $box[1] = Int($res[1])
       $box[2] = Int($res[2])
       $box[3] = Int($res[3])
       return $res
EndFunc