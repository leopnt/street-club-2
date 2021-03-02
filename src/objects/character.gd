extends KinematicBody2D

export (int) var life:int = 100
export (int) var power:int = 20
export (int) var jump:int = 2
export (int) var technique:int = 50
export (int) var speed:int = 100
var velocity:Vector2 = Vector2()
var look:Vector2 = Vector2.RIGHT

func _ready():
	$JumpTimer.wait_time = jump

func _move(dir:Vector2) -> void:
	""" should be called in a physics process """
	velocity = dir * speed
	if !velocity.x == 0.0: # prevent move up and down 0 size
		look.x = dir.project(Vector2.RIGHT).normalized().x
		$AttackRay.cast_to.x = technique * look.x
		$AnimatedSprite.flip_h = (velocity.x < 0)
	
	velocity = move_and_slide(velocity)
	$AnimatedSprite.play("run")

func _idle() -> void:
	$AnimatedSprite.play("idle")

func take_damage(damage:int) -> void:
	life -= damage
	print(self, " took damage. Life: ", life)
	if life <= 0:
		_dispose()

func _dispose() -> void:
	# virtual function to handle death of character
	pass

func _jump() -> void:
	#TODO: start timer
	# character can't take damage while in the air
	pass

func _punch() -> void:
	if $AttackRay.is_colliding():
		var collider = $AttackRay.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(power)
