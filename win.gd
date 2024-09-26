extends Control
@onready var button: Button = $Button




#code to mkake the button work, if pressed, will return to the main menu
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
