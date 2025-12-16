extends Control

func _ready():
	print("Menu principal carregado!")

func _on_start_button_pressed():
	print("Iniciar jogo!")
	get_tree().change_scene_to_file("res://scenes/levels/Level1_3d.tscn")

func _on_settings_button_pressed():
	print("Abrir configurações")
	#var settings_scene = load("res://scenes/ui/SettingsMenu.tscn")
	#var settings_instance = settings_scene.instantiate()
	#add_child(settings_instance)

func _on_credits_button_pressed():
	print("Mostrar créditos")

func _on_quit_button_pressed():
	get_tree().quit()
