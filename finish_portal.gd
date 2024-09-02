extends Area2D
var interactable = false
@onready var label = $Label

func _ready() -> void:
	label.hide()

func _on_body_entered(body: Node2D) -> void:
	print("hi")
	if body.is_in_group("player"):
		interactable = true
		label.show()

func _input(event):
	if event.is_action_pressed("interact") and interactable == true:
		LevelStats.update_level()
		get_tree().reload_current_scene()

func _on_body_exited(body: Node2D) -> void:
	label.hide()
