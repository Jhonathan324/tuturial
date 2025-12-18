extends Control
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
