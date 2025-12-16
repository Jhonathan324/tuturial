extends CharacterBody3D

var player
var speed = 2.0
var health = 50

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if not player:
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	velocity.y = 0
	
	move_and_slide()
	
	if global_position.y < -10:
		queue_free()

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
