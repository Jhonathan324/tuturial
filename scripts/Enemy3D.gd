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

func take_damage(amount):
	health -= amount
	print("Inimigo tomou dano: ", health)
	
	if health <= 0:
		die()

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
