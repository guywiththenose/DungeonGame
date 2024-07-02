extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var speed: int = 50

@onready var sprite = $PlayerSprite

func _process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
func _physics_process(delta):
	velocity = direction * speed
	
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
	
	move_and_slide()
	
