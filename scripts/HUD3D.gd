extends Control

@onready var level_label = $HBoxContainer/VBoxContainer/LevelLabel
@onready var lives_label = $HBoxContainer/VBoxContainer/LivesLabel
@onready var timer_label = $HBoxContainer/VBoxContainer/TimerLabel
@onready var difficulty_label = $HBoxContainer/VBoxContainer/DifficultyLabel

var points = 0

func _ready():
	# Primeiro, vamos verificar se encontramos os nós
	print("=== INICIANDO HUD3D ===")
	
	
	# Método 1: Procura por nomes únicos
	var score_node = get_node_or_null("ScoreLabel")
	var health_node = get_node_or_null("HealthLabel")
	
	if score_node:
		print("✓ ScoreLabel encontrado!")
		score_node.text = "PONTOS: 0"
	else:
		print("✗ ScoreLabel NÃO encontrado")
		# Cria um novo se não existir
		create_score_label()
	
	if health_node:
		print("✓ HealthLabel encontrado!")
		health_node.text = "VIDA: 100"
	else:
		print("✗ HealthLabel NÃO encontrado")
		# Cria um novo se não existir
		create_health_label()
	print("=== HUD PRONTO ===")
	
	# Conectar sinais do GameManager
	GameManager.level_changed.connect(update_level)
	GameManager.difficulty_changed.connect(update_difficulty)
	
	# Inicializar valores
	update_level(GameManager.current_level)
	update_difficulty(GameManager.current_difficulty)
	update_lives(GameManager.player_lives)

func create_score_label():
	var label = Label.new()
	label.name = "ScoreLabel"
	label.text = "PONTOS: 0"
	label.position = Vector2(20, 20)
	label.add_theme_font_size_override("font_size", 24)
	add_child(label)
	print("✓ ScoreLabel criado automaticamente")

func create_health_label():
	var label = Label.new()
	label.name = "HealthLabel"
	label.text = "VIDA: 100"
	label.position = Vector2(300, 20)
	label.add_theme_font_size_override("font_size", 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(label)
	print("✓ HealthLabel criado automaticamente")

# Funções para atualizar de outros scripts
func update_score(points_add):
	points = points + points_add 
	var label = get_node_or_null("ScoreLabel")
	if label:
		label.text = "PONTOS: " + str(points)

func update_health(health):
	var label = get_node_or_null("HealthLabel")
	if label:
		label.text = "VIDA: " + str(health)
		

func update_level(level):
	level_label.text = "NÍVEL: %d/%d" % [level, GameManager.max_levels]

func update_lives(lives):
	lives_label.text = "VIDAS: %d" % lives

func update_timer(seconds):
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	timer_label.text = "TEMPO: %02d:%02d" % [minutes, secs]

func update_difficulty(diff):
	var diff_names = {
		GameManager.Difficulty.EASY: "FÁCIL",
		GameManager.Difficulty.NORMAL: "NORMAL", 
		GameManager.Difficulty.HARD: "DIFÍCIL",
		GameManager.Difficulty.INSANE: "INSANO"
	}
	difficulty_label.text = "DIFICULDADE: %s" % diff_names[diff]
