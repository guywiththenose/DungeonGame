extends Control
#functions to make the start and quit buttons work
func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	
	get_tree().change_scene_to_file("res://Tilemap/main.tscn")
	PlayerStats.player_health = 100
	LevelStats.level_number = 0
