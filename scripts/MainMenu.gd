extends Control

func _ready():
	$StartButton.pressed.connect(_on_start_pressed)
	$SettingsButton.pressed.connect(_on_settings_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")

func _on_quit_pressed():
	get_tree().quit()
