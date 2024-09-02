extends Node

var level_number = 0
var numRooms = 10
var hSpread = 1.0
var enMin = 1
var enMax = 3
var boxes = false
var XF = 4
var YF = 7
var XW = 1
var YW = 1

func update_level():
	level_number += 1
	hSpread *= 1.2  
	enMin += 1
	enMax += 2
	numRooms += 5
	XF += 1
	YF += 1
	XW += 1 
	YW += 1
	if level_number > 3:
		boxes = true
