extends "res://src/objects/character.gd"


func _ready():
	power_off() # ennemy are paused by default

func _dispose():
	print("Ennemy::>", self, " queue_free...")
	queue_free()

func power_off() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	set_process(false)

func power_on() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	show()
	set_process(true)

func _process(delta):
	_look_at(Global.player.position - global_position)
	if _seek_and_arrive(Global.player.position):
		_smart_attack()
		

func _seek_and_arrive(targetPos:Vector2) -> bool:
	# follow player
	# returns true if has arrived
	
	var closest_pos = targetPos - $AttackRay.cast_to
	var dir = closest_pos - global_position
	
	var move_x = Vector2.ZERO
	var move_y = Vector2.ZERO
	
	var has_arrived:bool = true
	if abs(dir.x) > 1.0: # check arrived
		move_x = dir.project(Vector2.RIGHT).normalized()
		has_arrived = false
	if abs(dir.y) > 1.0:
		move_y = dir.project(Vector2.DOWN).normalized()
		has_arrived = false
	
	_move(move_x + move_y)
	return has_arrived

func _smart_attack() -> void:
	if $AttackTrigger.is_stopped():
		$AttackTrigger.wait_time = rand_range(1, 4)
		$AttackTrigger.start()

func _on_AttackTrigger_timeout():
	_punch()
