extends Control
@onready var button: Button = $Button
#same as menu screen
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
