extends Area2D

@export var speed = 250
var in_walls = false

func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)


func _on_body_entered(body):
	if body.is_in_group("walls"):
		speed = 0
		$AnimationPlayer.stop()
		in_walls = true
	elif body.is_in_group("enemy") and body.has_method("take_damage") and in_walls != true:
		body.take_damage(1)


func _on_timer_timeout():
	queue_free()
