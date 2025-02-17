extends Area2D

@export var speed = 250
var in_walls = false
var pierce = 2

func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
#code controls collisions. For example, if it is in an enemy, the enemy will take damage; if it is in a wall, it will stop moving
func _on_body_entered(body):
	if body.is_in_group("walls"):
		speed = 0
		$AnimationPlayer.stop()
		in_walls = true
	elif body.is_in_group("enemy") and body.has_method("take_damage") and in_walls != true:
		body.take_damage(1)
		pierce -= 1
		if pierce <= 0:
			queue_free()
#delets knife to prevent lag
func _on_timer_timeout():
	queue_free()
