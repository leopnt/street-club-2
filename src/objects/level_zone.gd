extends Node2D

# define ennemy class
const Ennemy = preload("res://src/objects/ennemy.gd")

var ennemies_remaining:int
export(bool) var is_last_level = false

func _ready():
	for child in get_children():
		if child is Ennemy:
			ennemies_remaining += 1
			child.connect("tree_exited", self, "_on_ennemy_tree_exited")

func _spawn_ennemies() -> void:
	for child in get_children():
		if child is Ennemy:
			child.power_on()

func _on_Area2D_body_entered(body):
	if body == Global.player:
		Global.camera.lock()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		_spawn_ennemies()

func _on_ennemy_tree_exited() -> void:
	ennemies_remaining -= 1
	if ennemies_remaining <= 0:
		_on_level_zone_cleared()

func _on_level_zone_cleared() -> void:
	Global.ui.show_win() if is_last_level else Global.camera.unlock()
