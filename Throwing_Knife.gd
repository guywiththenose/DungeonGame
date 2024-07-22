extends Area2D

@export var speed = 250

func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)


func _on_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()
