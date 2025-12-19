extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 8
@export var mouse_sensitivity = 0.002
@export var deceleration_speed = 10.0 
var paused = false
var pause_menu_scene = preload("res://scenes/ui/PauseMenu.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $PlayerCamera

@onready var gun = $WeaponHolder/Gun
var bullet_scene = preload("res://scenes/weapons/Bullet.tscn")
var can_shoot = true
var shoot_cooldown = 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 
func _input(event):
	if event.is_action_just_pressed("pause"):
		toggle_pause()
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Correção: Usar um valor específico para desaceleração
		velocity.x = move_toward(velocity.x, 0, deceleration_speed * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration_speed * delta)

	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	# Posicionar na arma
	bullet.global_position = gun.global_position
	
	# Definir direção (para onde a câmera está olhando)
	var forward = -camera.global_transform.basis.z
	bullet.set_direction(forward)
	
	# Tocar som de tiro
	if has_node("ShootSound"):
		$ShootSound.play()
		
	
func toggle_pause():
	paused = !paused
	
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		
		var pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		
		pause_menu.get_node("VBoxContainer/ContinueButton").pressed.connect(unpause)
		pause_menu.get_node("VBoxContainer/MainMenuButton").pressed.connect(go_to_main_menu)
		pause_menu.get_node("VBoxContainer/QuitButton").pressed.connect(quit_game)
	else:
		unpause()

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	if has_node("PauseMenu"):
		$PauseMenu.queue_free()
	
	paused = false

func go_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func quit_game():
	get_tree().quit()
