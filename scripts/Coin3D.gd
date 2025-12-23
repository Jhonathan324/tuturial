extends Area3D

var rotation_speed = 2.0
var bob_height = 0.2
var bob_speed = 2.0
var start_y

func _ready():
	add_to_group("coins")
	start_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta):
	rotate_y(rotation_speed * delta)
	position.y = start_y + sin(Time.get_ticks_msec() * 0.001 * bob_speed) * bob_height

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()
		body.get_node("../UILayer/HUD3D").update_score(10)

func collect():
	$AnimationPlayer.play("collect")
	await $AnimationPlayer.animation_finished
	queue_free()
	remove_from_group("coins")
	get_parent().check_level_complete()
