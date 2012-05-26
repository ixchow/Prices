;On Search -> Equipment pane:
Local $boxSearch

Local $boxNext

Local $boxItem

Local $boxDps

Local $boxBid

Local $boxBuyout

Local $boxTimeLeft

Local $boxItemTypeArrow
Local $boxItemTypeName
Local $boxItemTypeDropdown
Local $boxItemType[5] ;computed from TypeDropdown

Local $boxItemSubtypeArrow
Local $boxItemSubtypeName
Local $boxItemSubtypeDropdown
Local $boxItemSubtype[15] ;computed from SubtypeDropdown
Local $boxItemSubtypeScrollDown
Local $boxItemSubtypeScrollUp

Local $boxLevelMin
Local $boxLevelMax
Local $boxPref1Min

If @DesktopWidth == 1600 And @DesktopHeight == 1200 Then
	$boxSearch = ParseBox("X=201 Y=918 X=419 Y=946")
	$boxNext = ParseBox("X=1084 Y=901 X=1100 Y=918")
	$boxItem = ParseBox("X=559 Y=336 X=1037 Y=879")
	$boxDps = ParseBox("X=1050 Y=338 X=1106 Y=875")
	$boxBid = ParseBox("X=1106 Y=340 X=1224 Y=869")
	$boxBuyout = ParseBox("X=1219 Y=338 X=1341 Y=873")
	$boxTimeLeft = ParseBox("X=1335 Y=340 X=1466 Y=876")

	$boxItemTypeArrow = ParseBox("X=416 Y=414 X=438 Y=438")
	$boxItemTypeName = ParseBox("X=175 Y=411 X=408 Y=436")
	$boxItemTypeDropdown = ParseBox("X=184 Y=458 X=439 Y=630")

	$boxItemSubtypeArrow = ParseBox("X=416 Y=464 X=439 Y=487")
	$boxItemSubtypeName = ParseBox("X=175 Y=459 X=410 Y=487")
	$boxItemSubtypeDropdown = ParseBox("X=182 Y=506 X=408 Y=1029")
	$boxItemSubtypeScrollDown = ParseBox("X=417 Y=1006 X=433 Y=1023")
	$boxItemSubtypeScrollUp = ParseBox("X=417 Y=512 X=434 Y=530")

	$boxLevelMin = ParseBox("X=184 Y=557 X=209 Y=575")
	$boxLevelMax = ParseBox("X=263 Y=556 X=292 Y=577")
	$boxPref1Min = ParseBox("X=407 Y=653 X=433 Y=670")
ElseIf @DesktopWidth == 1680 And @DesktopHeight == 1050 Then
	$boxSearch = ParseBox("X=430 Y=812 X=433 Y=814")
	$boxNext = ParseBox("X=1096 Y=799 X=1097 Y=800")
	$boxItem = ParseBox("X=627 Y=297 X=1067 Y=769")
	$boxDps = ParseBox("X=1040 Y=297 X=1109 Y=769")
	$boxBid = ParseBox("X=1109 Y=297 X=1210 Y=769")
	$boxBuyout = ParseBox("X=1210 Y=297 X=1310 Y=769")
	$boxTimeLeft = ParseBox("X=1354 Y=297 X=1419 Y=769")
Else
	MsgBox(0, "Sorry", "Your screen size -- " & @DesktopWidth & " x " & @DesktopHeight & " -- unknown.");
	Exit
EndIf

; lengths
Local $lengthItemRowHeight = ($boxItem[3]-$boxItem[1])/11

For $i = 0 To 14
	Local $x1 = $boxItemSubtypeDropdown[0]
	Local $x2 = $boxItemSubtypeDropdown[2]
	Local $y1 = Int(($boxItemSubtypeDropdown[3] - $boxItemSubtypeDropdown[1]) * ($i + 0.1) / 15 + $boxItemSubtypeDropdown[1])
	Local $y2 = Int(($boxItemSubtypeDropdown[3] - $boxItemSubtypeDropdown[1]) * ($i + 0.9) / 15 + $boxItemSubtypeDropdown[1])
	$boxItemSubtype[$i] = ParseBox("X="&$x1&" Y="&$y1&" X="&$x2&" Y="&$y2)
Next

Func ParseBox($s)
	Local $res = StringRegExp($s, 'X=(\d+) Y=(\d+) X=(\d+) Y=(\d+)', 1)
	Local $box[4]
	$box[0] = Int($res[0])
	$box[1] = Int($res[1])
	$box[2] = Int($res[2])
	$box[3] = Int($res[3])
	return $res
EndFunc

Func ParsePix($s)
	Local $res = StringRegExp($s, 'X=(\d+) Y=(\d+)', 1)
	Local $box[2]
	$box[0] = Int($res[0])
	$box[1] = Int($res[1])
	return $res
EndFunc