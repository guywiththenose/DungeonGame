extends CharacterBody2D

@export var speed = 40
@export var health = 2
@export var damage = 5

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D
@onready var damagetimer = $Hitbox/Damagetimer
@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
@onready var los = $RayCast2D

var player_spotted = false

func _ready() -> void:
	# Optionally initialize any necessary logic here
	los.enabled = true

func check_collision():
	if not damagetimer.is_stopped():
		return
	var collisions = $Hitbox.get_overlapping_bodies()
	if collisions:
		for collision in collisions:
			if collision.is_in_group("player") and damagetimer.is_stopped():
				PlayerStats.damage_player(damage)
				damagetimer.start()

func _physics_process(delta: float) -> void:
	los.look_at(player.global_position)
	check_player_in_detection()
	if player_spotted:
		var direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = direction * speed
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

func check_player_in_detection() -> void:
	if los.is_colliding():
		var collider = los.get_collider()
		if collider and collider.is_in_group("player"):
			player_spotted = true
		else:
			player_spotted = false
	else:
		player_spotted = false

func make_path() -> void:
		navigation_agent.target_position = player.global_position

func _on_nav_timer_timeout():
	if player_spotted:
		make_path()
