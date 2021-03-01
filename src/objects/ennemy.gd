extends "res://src/objects/character.gd"


func _ready():
	pass

func _dispose():
	print(self, " queue_free...")
	queue_free()
