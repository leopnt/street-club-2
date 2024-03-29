"""
Template class for characters. This class is not meant to be used as-is
but only for child classes (see empty properties)
"""


extends KinematicBody2D

signal dead

export (int) var max_life:int = 100
onready var life:int = max_life
export (int) var power:int = 20 # damage for punch
export (int) var jump:int = 20 # target max jump height
export (int) var technique:int = 30 # damage for special punch
export (int) var speed:int = 50
onready var hit_range:int = $AttackRay.cast_to.length()
var velocity:Vector2 = Vector2()
var look:Vector2 = Vector2.RIGHT
var state_machine:AnimationNodeStateMachinePlayback

func _ready():
	state_machine = $Jumpable/AnimationTree.get("parameters/playback")
	# in the editor for child class, set AnimationTree/Active to true
	state_machine.start("idle")

func _move(dir:Vector2) -> void:
	""" should be called in a _process() """
	velocity = dir * speed
	velocity = move_and_slide(velocity)
	if !is_jumping():
		state_machine.travel("run")
	
	_idle() if (dir == Vector2.ZERO) else _look_at(dir)

func _look_at(dir:Vector2) -> void:
	if !dir.x == 0.0: # prevent 0 size rayCast for up/down move
		look.x = dir.project(Vector2.RIGHT).normalized().x
		$AttackRay.cast_to.x = hit_range * look.x
		$Jumpable/Sprite.flip_h = ($AttackRay.cast_to.x < 0)

func _idle() -> void:
	""" should be called in a _process() """
	if !is_jumping():
		state_machine.travel("idle")

func take_damage(damage:int) -> void:
	life -= damage
	Global.ui.update()
	print("Character::>", self, " took damage. Life: ", life)
	if is_dead():
		_dispose()

func is_dead() -> bool:
	if life <= 0:
		return true
	return false

func _dispose() -> void:
	# virtual function to handle death of character
	state_machine.travel("death")
	emit_signal("dead")

func _jump() -> void:
	if !is_jumping():
		var jump_speed = 1.4
		# reset jump tweens
		$Jumpable/JumpTween.interpolate_property($Jumpable, "position:y",
				0, -jump, 1 / jump_speed,
				Tween.TRANS_SINE, Tween.EASE_OUT)
		$Jumpable/FallTween.interpolate_property($Jumpable, "position:y",
				-jump, 0, 1 / jump_speed,
				Tween.TRANS_SINE, Tween.EASE_IN)
		
		# initialize jump sequence
		$Jumpable/JumpTween.start()
		print("jump start")
		state_machine.travel("jump")

func is_jumping() -> bool:
	if $Jumpable/JumpTween.is_active() || $Jumpable/FallTween.is_active():
		return true
	
	return false

func _punch() -> void:
	if $AttackRay.is_colliding():
		var collider = $AttackRay.get_collider()
		# check if collider is a Character object
		if collider.has_method("take_damage"):
			collider.take_damage(power)
			$Audio/punch.play()
	
	state_machine.travel("attack1")

func _special_punch() -> void:
	if $AttackRay.is_colliding():
		var collider = $AttackRay.get_collider()
		# check if collider is a Character object
		if collider.has_method("take_damage"):
			collider.take_damage(technique)
			$Audio/punch_special.play()
	
	state_machine.travel("attack2")

func _on_JumpTween_tween_completed(object, key):
	$Jumpable/FallTween.start()
	print("reached max jump")
	state_machine.travel("fall")

func _on_FallTween_tween_completed(object, key):
	print("jump end")

