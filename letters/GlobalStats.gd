extends Node

var current_stats setget ,get_current_stats

enum modifier_modes {
	ADD,
	MULTIPLY,
	INCREASE_PERCENT,
	DECREASE_PERCENT
}

class Stats:
	var player_speed = 1

func _ready():
	current_stats = Stats.new()
	print(current_stats.player_speed)
	current_stats["player_speed"] +=1

func reset():
	current_stats = Stats.new()

func apply_modifier(stat: String, modification, mode = modifier_modes.ADD):
	if !(stat in current_stats):
		push_error("invalid stat" + stat)
	
	var current_value = current_stats[stat]
	match(mode):
		modifier_modes.ADD:
			current_stats[stat] = current_value + modification
		modifier_modes.MULTIPLY:
			current_stats[stat] = current_value * modification
		modifier_modes.INCREASE_PERCENT:
			current_stats[stat] = current_value * (1 + 0.01 * modification)
		modifier_modes.DECREASE_PERCENT:
			current_stats[stat] = current_value * (1 - 0.01 * modification)


func get_current_stats():
	return current_stats