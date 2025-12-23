extends CharacterBody3D

@export var base_health = 50
@export var base_damage = 10
@export var base_speed = 2.0

var current_health = 50
var current_damage = 10
var current_speed = 2.0
var difficulty_multiplier = 1.0

var player
var speed = 2.0
var health = 50

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
# Adicionar ao grupo de inimigos
	add_to_group("enemies")
# Aplicar configurações de dificuldade
	apply_difficulty_settings()

func _physics_process(_delta):
	if not player:
		print("player não encontrado _physics_process")
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	velocity.y = 0
	
	move_and_slide()
	
	if global_position.y < -10:
		queue_free()



func die():
	
	# Efeito de morte
	var death_particles = GPUParticles3D.new()
	death_particles.amount = 50
	death_particles.lifetime = 1.0
	death_particles.one_shot = true
	
	get_parent().add_child(death_particles)
	death_particles.global_position = global_position
	death_particles.emitting = true
	
	# Remover inimigo
	queue_free()
	
	# Remover partículas após 2 segundos
	await get_tree().create_timer(2.0).timeout
	death_particles.queue_free()
	
	get_parent().queue_free()
	

func set_difficulty_settings(diff_config):
	# Ajustar stats baseado na dificuldade
	current_health = base_health * (diff_config.enemy_health / 50.0)
	current_damage = base_damage * (diff_config.enemy_damage / 10.0)
	current_speed = base_speed * (diff_config.enemy_speed / 2.0)
	
	# Aplicar visualmente (ex: inimigos mais difíceis = mais vermelhos)
	var material = $MeshInstance3D.get_surface_override_material(0)
	if material:
		var health_ratio = current_health / base_health
		var red_intensity = min(1.0, 0.5 + health_ratio * 0.5)
		material.albedo_color = Color(red_intensity, 0.2, 0.2)

func apply_difficulty_settings():
	# Pega configurações atuais do GameManager
	var settings = GameManager.get_current_settings()
	var diff_config = settings.difficulty
	
	set_difficulty_settings(diff_config)

func take_damage(amount):
	current_health -= amount
	
	await get_tree().create_timer(0.1).timeout
	$MeshInstance3D.material_override = null
	
	if current_health <= 0:
		die()
		return true
	return false
