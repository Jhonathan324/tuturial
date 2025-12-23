extends Control

func _ready():
	if GameManager.load_game():
		print("Jogo carregado do save")
	print("Menu principal carregado!")

func _on_difficulty_pressed():
	var difficulty_scene = preload("res://scenes/ui/DifficultyMenu.tscn")
	var instance = difficulty_scene.instantiate()
	add_child(instance)

func _on_continue_pressed():
	# Continuar de onde parou
	var level_scene = load("res://scenes/levels/Level1_3D.tscn")
	get_tree().change_scene_to_packed(level_scene)

func _on_new_game_pressed():
	# Resetar jogo
	GameManager.reset_game()
	_on_start_button_pressed()

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
