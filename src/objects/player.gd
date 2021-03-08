extends "res://src/objects/character.gd"

export (int) var max_stamina:int = 3
var stamina:int = max_stamina

func _ready():
	Global.player = self

func _process(delta):
	apply_inputs()

func apply_inputs() -> void:
	var move_dir = Vector2.ZERO
	if Input.is_action_pressed('ui_right'):
		move_dir.x += 1
	if Input.is_action_pressed('ui_left'):
		move_dir.x -= 1
	if Input.is_action_pressed('ui_down'):
		move_dir.y += 1
	if Input.is_action_pressed('ui_up'):
		move_dir.y -= 1
	move_dir = move_dir.normalized()
	
	_move(move_dir)

func _input(event):
	if event.is_action_type():
		if event.is_action_pressed("A") && stamina > 0:
			_special_punch()
		if event.is_action_pressed("B"):
			_punch()
		if event.is_action_pressed("C"):
			_jump()
			
		if stamina < max_stamina && $StaminaReloader.is_stopped():
			$StaminaReloader.start()


func _punch() -> void:
	._punch()

func _special_punch() -> void:
	._special_punch()
	stamina -= 1
	Global.ui.update()

func _dispose() -> void:
	print("Player::>player dead")
	._dispose()
	Global.ui.show_gameover()


func _on_StaminaReloader_timeout():
	if stamina < max_stamina:
		stamina += 1
		Global.ui.update()
	else:
		$StaminaReloader.stop()
