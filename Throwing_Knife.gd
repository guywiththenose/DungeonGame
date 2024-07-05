extends Area2D

func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
