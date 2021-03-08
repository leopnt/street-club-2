extends Node


func _ready():
	Global.audio = self
	$music1.play()


func _on_music1_finished():
	$music2.play()


func _on_music2_finished():
	$music3.play()


func _on_music3_finished():
	$music1.play()
