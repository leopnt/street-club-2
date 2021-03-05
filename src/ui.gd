extends Control

onready var progress_bar:ProgressBar = $MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/ProgressBar

func _ready():
	Global.ui = self

func update() -> void:
	var player = Global.player
	progress_bar.value = Utils.map(player.life, 0, player.max_life, 0, 100)
