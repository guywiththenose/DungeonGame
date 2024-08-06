extends CanvasLayer

@onready var health = $Control/Health

func _ready():
	PlayerStats.take_damage.connect(update_health)

func update_health():
	health.max_value = PlayerStats.player_max_health
	health.value = PlayerStats.player_health
