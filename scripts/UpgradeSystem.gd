extends Node

# Sistema de upgrades por nível
var player_upgrades = {
	"damage": 1.0,
	"health": 100,
	"speed": 5.0,
	"ammo": 30,
	"reload_speed": 2.0
}

var upgrade_costs = {
	"damage": 500,
	"health": 300,
	"speed": 400,
	"ammo": 200,
	"reload_speed": 600
}

func get_upgrade_cost(upgrade_name):
	return upgrade_costs[upgrade_name]

func purchase_upgrade(upgrade_name):
	var cost = upgrade_costs[upgrade_name]
	if GameManager.score >= cost:
		GameManager.score -= cost
		apply_upgrade(upgrade_name)
		return true
	return false

func apply_upgrade(upgrade_name):
	match upgrade_name:
		"damage":
			player_upgrades.damage += 0.2
		"health":
			player_upgrades.health += 25
		"speed":
			player_upgrades.speed += 0.5
		"ammo":
			player_upgrades.ammo += 10
		"reload_speed":
			player_upgrades.reload_speed = max(0.5, player_upgrades.reload_speed - 0.2)
	
	GameManager.save_game()

func get_player_stats():
	return player_upgrades
