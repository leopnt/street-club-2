extends "res://src/objects/character.gd"

export (int) var max_stamina:int = 20
var stamina:int = max_stamina

func _ready():
	pass

func _process(delta):
	apply_inputs()

func apply_inputs() -> void:
	var move_dir = Vector2()
	var is_move_input_active = false
	if Input.is_action_pressed('ui_right'):
		move_dir.x += 1
		is_move_input_active = true
	if Input.is_action_pressed('ui_left'):
		move_dir.x -= 1
		is_move_input_active = true
	if Input.is_action_pressed('ui_down'):
		move_dir.y += 1
		is_move_input_active = true
	if Input.is_action_pressed('ui_up'):
		move_dir.y -= 1
		is_move_input_active = true
	move_dir = move_dir.normalized()
	
	# avoid calling character move every frame
	_move(move_dir) if (is_move_input_active) else _idle()

func _input(event):
	if event.is_action_type():
		if stamina > 0:
			if event.is_action_pressed("A"):
				_special_punch()
			if event.is_action_pressed("B"):
				_punch()
			if event.is_action_pressed("C"):
				_jump()
				
			if stamina < max_stamina:
				$StaminaReloader.start()


func _punch() -> void:
	._punch()

func _special_punch() -> void:
	._special_punch()
	stamina -= 1

func _dispose() -> void:
	print("player dead")


func _on_StaminaReloader_timeout():
	if stamina < max_stamina:
		stamina += 1
	else:
		$StaminaReloader.stop()
