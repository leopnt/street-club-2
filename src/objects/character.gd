"""
Template class for characters. This class is not meant to be used as-is
but only for child classes (see empty properties)
"""


extends KinematicBody2D

export (int) var life:int = 100
export (int) var power:int = 20 # damage for punch
export (int) var jump:int = 40 # target max jump height
export (int) var technique:int = 50 # damage for special punch
export (int) var speed:int = 50
export (int) var hit_range:int = 30 # length of raycast
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
	if !velocity.x == 0.0: # prevent move up and down 0 size
		look.x = dir.project(Vector2.RIGHT).normalized().x
		$AttackRay.cast_to.x = hit_range * look.x
		$Jumpable/Sprite.flip_h = (velocity.x < 0)
		
	velocity = move_and_slide(velocity)
	if !is_jumping():
		state_machine.travel("run")

func _idle() -> void:
	""" should be called in a _process() """
	if !is_jumping():
		state_machine.travel("idle")

func take_damage(damage:int) -> void:
	life -= damage
	print(self, " took damage. Life: ", life)
	if life <= 0:
		_dispose()

func _dispose() -> void:
	# virtual function to handle death of character
	pass

func _jump() -> void:
	if !is_jumping():
		# reset jump tweens
		$Jumpable/JumpTween.interpolate_property($Jumpable, "position:y",
				0, -jump, 0.7,
				Tween.TRANS_SINE, Tween.EASE_OUT)
		$Jumpable/FallTween.interpolate_property($Jumpable, "position:y",
				-jump, 0, 0.7,
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
		if collider.has_method("take_damage"): # check it's a character
			collider.take_damage(power)
	
	state_machine.travel("attack1")

func _special_punch() -> void:
	if $AttackRay.is_colliding():
		var collider = $AttackRay.get_collider()
		if collider.has_method("take_damage"): # # check it's a character
			collider.take_damage(technique)
	
	state_machine.travel("attack2")

func _on_JumpTween_tween_completed(object, key):
	$Jumpable/FallTween.start()
	print("reached max jump")
	state_machine.travel("fall")

func _on_FallTween_tween_completed(object, key):
	print("jump end")

