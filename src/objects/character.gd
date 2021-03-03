extends KinematicBody2D

export (int) var life:int = 100
export (int) var power:int = 20
export (int) var jump:int = 60 # target max jump height
export (int) var technique:int = 50
export (int) var speed:int = 100
var velocity:Vector2 = Vector2()
var look:Vector2 = Vector2.RIGHT


func _ready():
	pass

func _move(dir:Vector2) -> void:
	""" should be called in a physics process """
	velocity = dir * speed
	if !velocity.x == 0.0: # prevent move up and down 0 size
		look.x = dir.project(Vector2.RIGHT).normalized().x
		$AttackRay.cast_to.x = technique * look.x
		$Jumpable/AnimatedSprite.flip_h = (velocity.x < 0)
	
	velocity = move_and_slide(velocity)
	$Jumpable/AnimatedSprite.play("run")

func _idle() -> void:
	if !is_jumping():
		$Jumpable/AnimatedSprite.play("idle")

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
				0, -jump, 1,
				Tween.TRANS_SINE, Tween.EASE_OUT)
		$Jumpable/FallTween.interpolate_property($Jumpable, "position:y",
				-jump, 0, 1,
				Tween.TRANS_SINE, Tween.EASE_IN)
		
		# initialize jump sequence
		$Jumpable/JumpTween.start()
		$Jumpable/AnimatedSprite.play("jump")
		print("jump start")

func is_jumping() -> bool:
	if $Jumpable/JumpTween.is_active() || $Jumpable/FallTween.is_active():
		return true
	
	return false

func _punch() -> void:
	if $AttackRay.is_colliding():
		var collider = $AttackRay.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(power)

func _on_JumpTween_tween_completed(object, key):
	$Jumpable/FallTween.start()
	print("reached max jump")

func _on_FallTween_tween_completed(object, key):
	print("jump end")

