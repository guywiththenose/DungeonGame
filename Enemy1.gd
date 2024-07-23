extends CharacterBody2D

@export var speed = 40

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D
@export var health = 2

func _physics_process(delta):
	var direction_to_player = global_position.direction_to(player.global_position)
	velocity = direction_to_player * speed
	
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	move_and_slide()

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
