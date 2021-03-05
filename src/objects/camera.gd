extends Camera2D

onready var locked:bool = false
var lerp_speed = 1.0 # variable speed to give a more old school sega feel

func _ready():
	Global.camera = self

func _process(delta):
	if !locked:
		lerp_speed = lerp(lerp_speed, 1.0, 0.001)
		if Global.player.position.x > position.x:
			position.x = lerp(position.x, Global.player.position.x, lerp_speed)

func lock() -> void:
	locked = true

func unlock() -> void:
	locked = false
	lerp_speed = 0.01
