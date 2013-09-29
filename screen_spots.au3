
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

If @DesktopWidth == 1600 And @DesktopHeight == 1200 Then ; ???
	$boxSearch = ParseBox("X=330 Y=803 X=495 Y=825")
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

ElseIf @DesktopWidth == 1280 And @DesktopHeight == 800 Then ; luxchow


$boxSearch = ParseBox("X=257 Y=614 X=373 Y=629")

$boxCraftingQuantity = ParseBox("X=302 Y=404 X=337 Y=411")
$boxCraftingPPU = ParseBox("X=696 Y=228 X=799 Y=245")
$boxCraftingLast10 = ParseBox("X=667 Y=311 X=836 Y=332")
$boxCraftingLastDay = ParseBox("X=688 Y=333 X=889 Y=354")
$boxCraftingMenu0Arrow = ParseBox("X=384 Y=229 X=395 Y=238")
$boxCraftingMenu1Arrow = ParseBox("X=385 Y=286 X=392 Y=294")
$boxCraftingMenu2Arrow = ParseBox("X=386 Y=348 X=393 Y=354")
Local $boxCraftingMenu0Dropdown = ParseBox("X=230 Y=258 X=398 Y=296")
$boxCraftingMenu1Dropdown = ParseBox("X=229 Y=315 X=407 Y=644")
$boxCraftingMenu2Dropdown = ParseBox("X=231 Y=374 X=393 Y=434")
$boxCraftingMenu1ScrollDown = ParseBox("X=535 Y=479 X=535 Y=479")
$boxCraftingMenu1ScrollUp = ParseBox("X=535 Y=479 X=535 Y=479")
$boxLevelMin = ParseBox("X=535 Y=479 X=535 Y=479")
$boxLevelMax = ParseBox("X=535 Y=479 X=535 Y=479")
$boxPref1Min = ParseBox("X=535 Y=479 X=535 Y=479")

ElseIf @DesktopWidth == 1680 And @DesktopHeight == 1050 Then ; cicero
	$checksumProcessingAuction = ParseBox("X=751 Y=259 X=927 Y=274")
	$tabCompleted = ParseBox("X=1064 Y=140 X=1240 Y=164")
	$tabSearch = ParseBox("X=432 Y=137 X=606 Y=161")
	$boxCompletedTransaction = ParseBox("X=1096 Y=291 X=1284 Y=306")
	$boxCompletedAmount = ParseBox("X=1284 Y=291 X=1391 Y=305")
	$boxCraftingBuyout = ParseBox("X=1204 Y=301 X=1341 Y=318")
	$boxCraftingBuyoutConfirm = ParseBox("X=644 Y=740 X=818 Y=775")
	$boxAuctionOK = ParseBox("X=752 Y=427 X=922 Y=467")
	$boxSendToStash = ParseBox("X=312 Y=421 X=506 Y=447")


	$boxLevelMin = ParseBox("X=302 Y=488 X=319 Y=498")
	$boxLevelMax = ParseBox("X=373 Y=487 X=388 Y=497")
	$boxPref1Min = ParseBox("X=498 Y=575 X=515 Y=582")
	$boxItemTypeArrow = ParseBox("X=507 Y=366 X=519 Y=375")
	$boxItemTypeName = ParseBox("X=294 Y=360 X=490 Y=378")
	$boxItemSubtypeArrow = ParseBox("X=505 Y=406 X=520 Y=419")
	$boxItemSubtypeName = ParseBox("X=296 Y=403 X=493 Y=423")
	$boxItemTypeDropdown = ParseBox("X=291 Y=438 X=526 Y=901")
	$boxItemSubtypeDropdown = ParseBox("X=291 Y=393 X=522 Y=550")
	$boxItemSubtypeScrollDown = ParseBox("X=505 Y=883 X=514 Y=889")
	$boxItemSubtypeScrollUp = ParseBox("X=508 Y=453 X=515 Y=460")
	$boxSearch = ParseBox("X=327 Y=807 X=496 Y=824")
	$boxNext = ParseBox("X=1091 Y=792 X=1097 Y=798")
	$boxItem = ParseBox("X=627 Y=295 X=1014 Y=770")
	$boxDps = ParseBox("X=1036 Y=296 X=1107 Y=761")
	$boxBid = ParseBox("X=1107 Y=301 X=1211 Y=764")
	$boxBuyout = ParseBox("X=1211 Y=299 X=1315 Y=762")
	$boxTimeLeft = ParseBox("X=1312 Y=298 X=1420 Y=761")

	;crafting
	$boxCraftingQuantity = ParseBox("X=355 Y=527 X=463 Y=543")
	$boxCraftingPPU = ParseBox("X=905 Y=298 X=1031 Y=327")
	$boxCraftingLast10 = ParseBox("X=875 Y=415 X=1112 Y=434")
	$boxCraftingLastDay = ParseBox("X=902 Y=441 X=1133 Y=462")
	$boxCraftingMenu0Arrow = ParseBox("X=505 Y=301 X=517 Y=312")
	$boxCraftingMenu1Arrow = ParseBox("X=504 Y=374 X=523 Y=391")
	$boxCraftingMenu2Arrow = ParseBox("X=505 Y=453 X=521 Y=467")
	$boxCraftingMenu0Dropdown = ParseBox("X=300 Y=337 X=525 Y=395")
	$boxCraftingMenu1Dropdown = ParseBox("X=300 Y=413 X=500 Y=870")
	$boxCraftingMenu2Dropdown = ParseBox("X=301 Y=491 X=523 Y=578")
	$boxCraftingMenu1ScrollDown = ParseBox("X=547 Y=854 X=555 Y=864")
	$boxCraftingMenu1ScrollUp = ParseBox("X=546 Y=419 X=555 Y=427")
Else
	MsgBox(0, "Sorry", "Your screen size -- " & @DesktopWidth & " x " & @DesktopHeight & " -- unknown.");
	Exit
EndIf


; compute items in dropdowns
;$boxItemSubtype = SplitDropdown($boxItemSubtypeDropdown, 15)
$boxCraftingMenu0 = SplitDropdown($boxCraftingMenu0Dropdown, 2)
$boxCraftingMenu1 = SplitDropdown($boxCraftingMenu1Dropdown, 15) ; dye type or difficulty
$boxCraftingMenu2 = SplitDropdown($boxCraftingMenu2Dropdown, 3) ; material

; lengths
;Local $lengthItemRowHeight = ($boxItem[3]-$boxItem[1])/11

Func SplitDropdown($dropdown, $numItems)
	Local $items[$numItems]
	For $i = 0 To $numItems-1
		Local $x1 = $dropdown[0]
		Local $x2 = $dropdown[2]
		Local $y1 = Int(($dropdown[3] - $dropdown[1]) * ($i + 0.2) / $numItems + $dropdown[1])
		Local $y2 = Int(($dropdown[3] - $dropdown[1]) * ($i + 0.8) / $numItems + $dropdown[1])
		$items[$i] = ParseBox("X="&$x1&" Y="&$y1&" X="&$x2&" Y="&$y2)
	Next
	Return $items
EndFunc


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