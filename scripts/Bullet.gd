extends Area3D

@export var speed = 50.0
@export var damage = 10
@export var max_distance = 100.0

var direction = Vector3.FORWARD
var traveled_distance = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Mover a bala
	var movement = direction * speed * delta
	global_translate(movement)
	
	# Atualizar distância percorrida
	traveled_distance += movement.length()
	
	# Destruir se viajou muito
	if traveled_distance > max_distance:
		queue_free()

func _on_body_entered(body):
	# Ignorar o jogador que atirou
	if body.is_in_group("player"):
		return
	
	# Causar dano a inimigos
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	
	# Efeito de impacto
	spawn_impact_effect()
	
	# Destruir a bala
	queue_free()

func spawn_impact_effect():
	# Criar efeito de impacto simples
	var impact_particles = GPUParticles3D.new()
	impact_particles.amount = 10
	impact_particles.lifetime = 0.5
	impact_particles.explosiveness = 1.0
	impact_particles.one_shot = true
	
	get_parent().add_child(impact_particles)
	impact_particles.global_position = global_position
	impact_particles.emitting = true
	
	# Remover após terminar
	await get_tree().create_timer(1.0).timeout
	impact_particles.queue_free()

func set_direction(new_direction: Vector3):
	direction = new_direction.normalized()
	# Apontar a bala na direção do movimento
	look_at(global_position + direction, Vector3.UP)
