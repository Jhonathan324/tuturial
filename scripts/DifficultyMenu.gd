extends Control

@onready var easy_button = $CenterContainer/ButtonContainer/EasyButton
@onready var normal_button = $CenterContainer/ButtonContainer/NormalButton
@onready var hard_button = $CenterContainer/ButtonContainer/HardButton
@onready var insane_button = $CenterContainer/ButtonContainer/InsaneButton
@onready var back_button = $CenterContainer/ButtonContainer/BackButton

func _ready():
	easy_button.pressed.connect(_on_easy_pressed)
	normal_button.pressed.connect(_on_normal_pressed)
	hard_button.pressed.connect(_on_hard_pressed)
	insane_button.pressed.connect(_on_insane_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Destacar dificuldade atual
	highlight_current_difficulty()

func highlight_current_difficulty():
	# Resetar todos
	easy_button.modulate = Color.WHITE
	normal_button.modulate = Color.WHITE
	hard_button.modulate = Color.WHITE
	insane_button.modulate = Color.WHITE
	
	# Destacar atual
	match GameManager.current_difficulty:
		GameManager.Difficulty.EASY:
			easy_button.modulate = Color.GREEN
		GameManager.Difficulty.NORMAL:
			normal_button.modulate = Color.YELLOW
		GameManager.Difficulty.HARD:
			hard_button.modulate = Color.ORANGE
		GameManager.Difficulty.INSANE:
			insane_button.modulate = Color.RED

func _on_easy_pressed():
	GameManager.set_difficulty(GameManager.Difficulty.EASY)
	queue_free()

func _on_normal_pressed():
	GameManager.set_difficulty(GameManager.Difficulty.NORMAL)
	queue_free()

func _on_hard_pressed():
	GameManager.set_difficulty(GameManager.Difficulty.HARD)
	queue_free()

func _on_insane_pressed():
	GameManager.set_difficulty(GameManager.Difficulty.INSANE)
	queue_free()

func _on_back_pressed():
	queue_free()
