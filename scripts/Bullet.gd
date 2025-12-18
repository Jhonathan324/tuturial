extends RigidBody3D

var damage = 50
var lifetime = 3.0

func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	print("Bala colidiu com: ", body.name)
	if body.is_in_group("enemies"):
		print("É um inimigo!")
		body.take_damage(damage)
	queue_free()
