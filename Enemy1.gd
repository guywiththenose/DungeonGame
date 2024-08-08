extends CharacterBody2D

@export var speed = 40

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D
@export var health = 2
@onready var damagetimer = $Hitbox/Damagetimer
@export var damage = 5

func check_collision():
	if not damagetimer.is_stopped():
		return
	var collisions = $Hitbox.get_overlapping_bodies()
	if collisions:
		for collision in collisions:
			if collision.is_in_group("player") and damagetimer.is_stopped():
				PlayerStats.damage_player(damage)
				damagetimer.start()
				
func _physics_process(delta):
	
	
	var direction_to_player = global_position.direction_to(player.global_position)
	velocity = direction_to_player * speed
	
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	move_and_slide()
	check_collision()

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
