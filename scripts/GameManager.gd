extends Node

# Singleton (autoload depois)
class_name GameManagerSingleton

# Sinais
signal level_changed(level_number)
signal difficulty_changed(difficulty)
signal score_updated(points)
signal game_over
signal game_won

# Configurações do jogo
enum Difficulty {EASY, NORMAL, HARD, INSANE}
var current_difficulty = Difficulty.NORMAL
var current_level = 1
var max_levels = 5
var score = 0
var player_lives = 3

# Configurações por dificuldade
var difficulty_settings = {
	Difficulty.EASY: {
		"enemy_health": 30,
		"enemy_damage": 5,
		"enemy_speed": 1.5,
		"spawn_rate": 0.5,
		"coin_spawn": 2.0
	},
	Difficulty.NORMAL: {
		"enemy_health": 50,
		"enemy_damage": 10,
		"enemy_speed": 2.0,
		"spawn_rate": 1.0,
		"coin_spawn": 1.5
	},
	Difficulty.HARD: {
		"enemy_health": 80,
		"enemy_damage": 15,
		"enemy_speed": 2.5,
		"spawn_rate": 1.5,
		"coin_spawn": 1.0
	},
	Difficulty.INSANE: {
		"enemy_health": 120,
		"enemy_damage": 25,
		"enemy_speed": 3.0,
		"spawn_rate": 2.0,
		"coin_spawn": 0.5
	}
}

# Configurações por nível
var level_settings = {
	1: {"size": 20, "enemies": 5, "coins": 10, "obstacles": 3, "time_limit": 120},
	2: {"size": 25, "enemies": 8, "coins": 15, "obstacles": 5, "time_limit": 150},
	3: {"size": 30, "enemies": 12, "coins": 20, "obstacles": 8, "time_limit": 180},
	4: {"size": 35, "enemies": 15, "coins": 25, "obstacles": 12, "time_limit": 210},
	5: {"size": 40, "enemies": 20, "coins": 30, "obstacles": 15, "time_limit": 240}
}

func _ready():
	# Salvar referência global
	_setup_as_singleton()

func _setup_as_singleton():
	# Garante que só existe um GameManagerSingleton
	if get_tree().root.has_node("GameManagerSingleton"):
		queue_free()
	else:
		get_tree().root.add_child(self)
		name = "GameManagerSingleton"

func set_difficulty(diff: Difficulty):
	current_difficulty = diff
	print("Dificuldade alterada para: ", diff)
	difficulty_changed.emit(diff)
	save_game()

func next_level():
	if current_level < max_levels:
		current_level += 1
		print("Indo para nível: ", current_level)
		level_changed.emit(current_level)
		save_game()
		return true
	else:
		game_won.emit()
		return false

func restart_level():
	# Mantém dificuldade mas reinicia nível
	score = 0
	score_updated.emit(score)
	print("Reiniciando nível ", current_level)

func add_score(points: int):
	score += points
	score_updated.emit(score)

func lose_life():
	player_lives -= 1
	if player_lives <= 0:
		game_over.emit()
		return false
	return true

func reset_game():
	current_level = 1
	score = 0
	player_lives = 3
	save_game()

func get_current_settings():
	var level_setting = level_settings[current_level]
	var diff_setting = difficulty_settings[current_difficulty]
	
	return {
		"level": level_setting,
		"difficulty": diff_setting
	}

func save_game():
	var save_data = {
		"current_level": current_level,
		"current_difficulty": current_difficulty,
		"score": score,
		"player_lives": player_lives
	}
	
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game():
	if FileAccess.file_exists("user://savegame.dat"):
		var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data = file.get_var()
		file.close()
		
		current_level = save_data.current_level
		current_difficulty = save_data.current_difficulty
		score = save_data.score
		player_lives = save_data.player_lives
		return true
	return false
