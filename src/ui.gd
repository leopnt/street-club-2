extends Control

onready var progress_bar:ProgressBar = $MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/ProgressBar

func _ready():
	Global.ui = self
	$EnterGameScreen/AnimationPlayer.play("FadeOut")

func update() -> void:
	var player = Global.player
	progress_bar.value = Utils.map(player.life, 0, player.max_life, 0, 100)

func show_gameover() -> void:
	$GameoverScreen/AnimationPlayer.play("fade_in")
	$GameoverScreen/VBoxContainer/ButtonRetry.grab_focus()


func _on_ButtonRetry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
