extends CharacterBody2D
const throwing_knife = preload("res://Throwing_Knife.tscn")

var direction: Vector2 = Vector2.ZERO
@export var speed: int = 50

@onready var sprite = $PlayerSprite
@onready var main = get_node('/root/Main')

func _process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("attack"):
		knife()

func _physics_process(delta):
	velocity = direction * speed
	
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
		
		
	move_and_slide()

func knife():
	var knife = throwing_knife.instantiate()
	knife.global_position = global_position
	knife.rotation(direction.angle())
	main.add_child(knife)
	

	
