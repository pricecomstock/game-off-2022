extends Node

var current_stats setget ,get_current_stats
var buffs: Dictionary = {}
var debuffs: Dictionary = {}

enum ModifierMode {
	ADD,
	MULTIPLY,
	INCREASE_PERCENT,
	DECREASE_PERCENT
}

class Stats:
	var player_speed = 1

class Buff:
	var stat : String
	var mod_mode: int
	var value

func _ready():
	current_stats = Stats.new()
	print(current_stats.player_speed)
	current_stats["player_speed"] +=1

func reset():
	current_stats = Stats.new()

func apply_modifier(stat: String, modification, mode = ModifierMode.ADD):
	if !(stat in current_stats):
		push_error("invalid stat" + stat)
	
	var current_value = current_stats[stat]
	match(mode):
		ModifierMode.ADD:
			current_stats[stat] = current_value + modification
		ModifierMode.MULTIPLY:
			current_stats[stat] = current_value * modification
		ModifierMode.INCREASE_PERCENT:
			current_stats[stat] = current_value * (1 + 0.01 * modification)
		ModifierMode.DECREASE_PERCENT:
			current_stats[stat] = current_value * (1 - 0.01 * modification)

func get_current_stats():
	return current_stats