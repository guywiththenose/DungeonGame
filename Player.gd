extends CharacterBody2D
const throwing_knife = preload("res://Throwing_Knife.tscn")

var direction: Vector2 = Vector2.ZERO
@export var speed: int = 50
var knife_ready = false

@onready var sprite = $PlayerSprite
@onready var main = get_node('/root/Main')
@onready var animation_player = $AnimationPlayer
@onready var red = $red
@onready var UI = $UI

signal enemy
#connects to player data singleton, reducing health and flashing red when enemy collides
func _ready():
	PlayerStats.take_damage.connect(player_damage)
	UI.update_health()
	
#codes for player movement. Movement is orthagonal and works with WASD keys and click for knife
func _process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("attack") and knife_ready == true:
		knife()
		knife_ready = false

func _physics_process(delta):
	velocity = direction * speed
	
	if velocity.x > 0:
		sprite.flip_h = false
		red.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true
		red.flip_h = true
		
	move_and_slide()
#creates knife when clicked
func knife():
	var knife = throwing_knife.instantiate()
	knife.global_position = global_position
	knife.rotate(global_position.direction_to(get_global_mouse_position()).angle())
	main.add_child(knife)

func _on_timer_timeout():
	knife_ready = true

func player_damage():
	animation_player.play("opacity")
