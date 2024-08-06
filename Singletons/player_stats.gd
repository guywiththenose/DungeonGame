extends Node

var player_health = 100
var player_max_health = 100

signal take_damage

func damage_player(amount):
	player_health -= amount
	emit_signal("take_damage")
	
