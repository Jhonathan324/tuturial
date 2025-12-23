extends Node

@onready var level_generator = $LevelGenerator
@onready var player = $Player3D
@onready var hud = $CanvasLayer/HUD3D

var current_level_data = {}
var level_timer = 0.0
var level_time_limit = 120.0
var is_level_active = false

func _ready():
	# Conectar sinais
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.difficulty_changed.connect(_on_difficulty_changed)
	
	# Iniciar primeiro nível
	start_level()

func start_level():
	var settings = GameManager.get_current_settings()
	current_level_data = settings.level
	
	# Configurar temporizador
	level_time_limit = current_level_data.time_limit
	level_timer = level_time_limit
	is_level_active = true
	
	# Gerar nível
	level_generator.generate_level()
	
	# Posicionar jogador em spawn aleatório
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	if spawn_points.size() > 0:
		var random_spawn = spawn_points[randi() % spawn_points.size()]
		player.global_position = random_spawn.global_position
	
	# Atualizar HUD
	hud.update_level(GameManager.current_level)
	hud.update_timer(level_timer)

func _process(delta):
	if is_level_active:
		level_timer -= delta
		hud.update_timer(level_timer)
		
		if level_timer <= 0:
			level_failed("Tempo esgotado!")

func level_complete():
	is_level_active = false
	print("Nível ", GameManager.current_level, " completo!")
	
	# Bônus por tempo restante
	var time_bonus = int(level_timer) * 10
	GameManager.add_score(time_bonus)
	
	# Próximo nível após delay
	await get_tree().create_timer(3.0).timeout
	
	if GameManager.next_level():
		start_level()
	else:
		game_won()

func level_failed(reason: String):
	is_level_active = false
	print("Nível falhou: ", reason)
	
	# Remover vida
	if not GameManager.lose_life():
		return
	
	# Reiniciar nível após delay
	await get_tree().create_timer(3.0).timeout
	start_level()

func game_won():
	print("JOGO COMPLETO! VOCÊ VENCEU!")
	# Mostrar tela de vitória
	var win_scene = preload("res://scenes/ui/WinScreen.tscn")
	add_child(win_scene.instantiate())

func _on_level_changed(new_level):
	print("Nível mudou para: ", new_level)
	hud.update_level(new_level)

func _on_difficulty_changed(new_difficulty):
	print("Dificuldade alterada")
	# Reiniciar nível com nova dificuldade
	start_level()
