extends Node

@export var enemy_scene: PackedScene
@export var max_enemies = 20
@export var spawn_interval = 5.0
@export var level_size = 10

var enemies_spawned = 0
var current_enemies = 0
var spawn_timer = 0.0
var spawn_points = []
var is_active = false

func _ready():
	# Encontrar pontos de spawn
	find_spawn_points()
	
	# Conectar sinais
	GameManager.difficulty_changed.connect(_on_difficulty_changed)
	
	# Iniciar com base na dificuldade
	update_spawn_settings()

func find_spawn_points():
	spawn_points = get_tree().get_nodes_in_group("spawn_points")
	if spawn_points.size() == 0:
		# Criar pontos de spawn automáticos se não existirem
		create_automatic_spawn_points()

func create_automatic_spawn_points():
	for i in range(8):
		var spawn_point = Node3D.new()
		spawn_point.name = "AutoSpawn_" + str(i)
		spawn_point.add_to_group("spawn_points")
		
		# Adicionar à cena primeiro
		add_child(spawn_point)
		
		# Agora posicionar
		var angle = i * (360.0 / 8.0)
		var radius = level_size * 0.6  # 60% do tamanho do nível
		var x = sin(deg_to_rad(angle)) * radius
		var z = cos(deg_to_rad(angle)) * radius
		
		spawn_point.global_position = Vector3(x, 0.5, z)
		
		# Debug visual - opcional
		create_spawn_marker(spawn_point.global_position)
		
		spawn_points.append(spawn_point)
		

		
func create_spawn_marker(position: Vector3):
	# Criar marcador visual para debug
	var marker = MeshInstance3D.new()
	marker.mesh = SphereMesh.new()
	(marker.mesh as SphereMesh).radius = 0.3
	marker.material_override = StandardMaterial3D.new()
	(marker.material_override as StandardMaterial3D).albedo_color = Color(1, 0, 0, 0.5)
	
	add_child(marker)
	marker.global_position = position
	
	# Remover após alguns segundos
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(marker):
		marker.queue_free()

func _process(delta):
	if not is_active or spawn_points.size() == 0:
		return
	
	spawn_timer -= delta
	
	if spawn_timer <= 0 and current_enemies < max_enemies:
		spawn_enemy()
		spawn_timer = spawn_interval

func spawn_enemy():
	if enemies_spawned >= max_enemies:
		return
	
	# Escolher ponto de spawn aleatório
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	
	# Verificar se está longe do jogador
	var player = get_tree().get_nodes_in_group("player")[0]
	if player and player.global_position.distance_to(spawn_point.global_position) < 10.0:
		# Muito perto do jogador, escolher outro ponto
		return
	
	# Instanciar inimigo
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_point.global_position
	
	# Aplicar dificuldade
	if enemy.has_method("apply_difficulty_settings"):
		enemy.apply_difficulty_settings()
	
	enemies_spawned += 1
	current_enemies += 1
	
	# Conectar sinal de morte
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))

func _on_enemy_died(_enemy):
	current_enemies -= 1
	# Adicionar pontos
	GameManager.add_score(100)

func update_spawn_settings():
	var settings = GameManager.get_current_settings()
	var diff_config = settings.difficulty
	
	# Ajustar spawn rate baseado na dificuldade
	spawn_interval = 5.0 / diff_config.spawn_rate
	
	# Ajustar máximo de inimigos baseado no nível
	var level_config = settings.level
	max_enemies = level_config.enemies * 2  # Inimigos extras durante jogo

func _on_difficulty_changed(_new_difficulty):
	update_spawn_settings()

func start_spawning():
	is_active = true
	spawn_timer = spawn_interval

func stop_spawning():
	is_active = false
