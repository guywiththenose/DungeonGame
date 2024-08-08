extends Node

var player_health = 100
var player_max_health = 100

signal take_damage
signal dead

func damage_player(amount):
	player_health -= amount
	emit_signal("take_damage")
	if player_health <= 0:
		emit_signal("dead")
