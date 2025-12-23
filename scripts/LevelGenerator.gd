extends Node3D

# Cenas para instanciar
@export var enemy_scene: PackedScene
@export var coin_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var spawn_point_scene: PackedScene

# Referências
@onready var floor_node = $Floor
var rng = RandomNumberGenerator.new()
var spawned_objects = []
var level_size = 20.0

func _ready():
	rng.randomize()
	generate_level()

func generate_level():
	# Limpar nível anterior
	clear_level()
	
	# Obter configurações do GameManager
	var settings = GameManager.get_current_settings()
	var level_config = settings.level
	var diff_config = settings.difficulty
	
	# Atualizar tamanho do nível
	level_size = level_config.size
	
	# Ajustar chão
	if floor_node:
		floor_node.scale = Vector3(level_size / 10, 0.5, level_size / 10)
	
	# Gerar objetos
	generate_obstacles(level_config.obstacles)
	generate_coins(level_config.coins)
	generate_enemies(level_config.enemies, diff_config)
	generate_spawn_points(4)  # Pontos de spawn do jogador

func generate_obstacles(count: int):
	for i in range(count):
		# Escolher tipo de obstáculo aleatório
		var obstacle_type = rng.randi_range(1, 3)
		var obstacle_scene_to_use = obstacle_scene
		
		# Criar posição aleatória
		var pos = get_random_position(10.0)
		
		# Instanciar obstáculo
		var obstacle = obstacle_scene_to_use.instantiate()
		add_child(obstacle)
		obstacle.global_position = pos
		
		# Aleatorizar escala
		var scale_factor = rng.randf_range(0.5, 2.0)
		obstacle.scale = Vector3(scale_factor, scale_factor, scale_factor)
		
		# Aleatorizar rotação
		if obstacle.has_method("rotate_y"):
			obstacle.rotate_y(rng.randf_range(0, 360))
		
		spawned_objects.append(obstacle)

func generate_coins(count: int):
	for i in range(count):
		var pos = get_random_position(8.0)
		
		# Verificar se posição está longe de obstáculos
		if is_position_valid(pos, 2.0):
			var coin = coin_scene.instantiate()
			add_child(coin)
			coin.global_position = pos
			
			# Aleatorizar altura
			coin.global_position.y = rng.randf_range(0.5, 2.0)
			
			spawned_objects.append(coin)

func generate_enemies(count: int, diff_config):
	for i in range(count):
		var pos = get_random_position(level_size - 5)
		
		if is_position_valid(pos, 3.0):
			var enemy = enemy_scene.instantiate()
			add_child(enemy)
			enemy.global_position = pos
			
			# Aplicar configurações de dificuldade
			if enemy.has_method("set_difficulty_settings"):
				enemy.set_difficulty_settings(diff_config)
			
			spawned_objects.append(enemy)

func generate_spawn_points(count: int):
	for i in range(count):
		var pos = get_random_position(level_size - 2)
		
		if is_position_valid(pos, 5.0):
			var spawn_point = spawn_point_scene.instantiate()
			add_child(spawn_point)
			spawn_point.global_position = pos
			
			# Nomear para referência
			spawn_point.name = "SpawnPoint_" + str(i)
			
			spawned_objects.append(spawn_point)

func get_random_position(margin: float = 5.0) -> Vector3:
	var half_size = level_size / 2.0
	var x = rng.randf_range(-half_size + margin, half_size - margin)
	var z = rng.randf_range(-half_size + margin, half_size - margin)
	
	return Vector3(x, 0.5, z)

func is_position_valid(pos: Vector3, min_distance: float) -> bool:
	for obj in spawned_objects:
		if obj.global_position.distance_to(pos) < min_distance:
			return false
	return true

func clear_level():
	for obj in spawned_objects:
		if is_instance_valid(obj):
			obj.queue_free()
	spawned_objects.clear()

# Chamar quando jogador coletar todas moedas
func check_level_complete():
	var coins_remaining = get_tree().get_nodes_in_group("coins").size()
	if coins_remaining == 0:
		level_complete()

func level_complete():
	print("Nível completo!")
	GameManager.next_level()
	# Gerar próximo nível após delay
	await get_tree().create_timer(2.0).timeout
	generate_level()
