extends Node

var level_number = 0
var numRooms = 10
var hSpread = 1.0
var enMin = 1
var enMax = 3
var boxes = false

func update_level():
	level_number += 1
	hSpread *= 1.2  
	enMin += 1
	enMax += 2
	numRooms += 5
	if level_number > 3:
		boxes = true
