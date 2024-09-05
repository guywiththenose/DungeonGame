extends Node

var level_number = 0
var numRooms = 10
var hSpread = 1.0
var enMin = 1
var enMax = 3
var boxes = false
var XF = 1
var YF = 0
var XW = 0
var YW = 0
var minsfactor = 1
var maxsfactor = 1
var end = false

func update_level():
	minsfactor += 0.05
	maxsfactor += 0.05
	level_number += 1
	hSpread *= 1.2  
	enMin += 1
	enMax += 2
	numRooms += 5
	XF += 1
	YF += 1
	XW += 1 
	YW += 1
	if level_number >= 3:
		boxes = true
	if level_number >= 8:
		end = true
