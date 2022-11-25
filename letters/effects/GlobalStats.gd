extends Node

signal stats_updated

var current_stats

# Creates a dictionary with a value of 1.0 in every stat
func get_base_stats() -> Dictionary:
  var stats = {}
  for attr in Stats.ATTRIBUTES:
    stats[attr] = 1.0
  
  return stats

func _ready():
  reset()

func reset():
  current_stats = get_base_stats()

func apply_buff(buff: Buff):
  var current_value = current_stats[buff.attribute]
  match(buff.mod_mode):
    Stats.MOD_MODE.ADD:
      current_stats[buff.attribute] = current_value + buff.amount
    Stats.MOD_MODE.MULTIPLY:
      current_stats[buff.attribute] = current_value * buff.amount
    Stats.MOD_MODE.INCREASE_PERCENT:
      current_stats[buff.attribute] = current_value * (1 + 0.01 * buff.amount)
    Stats.MOD_MODE.DECREASE_PERCENT:
      current_stats[buff.attribute] = current_value * (1 - 0.01 * buff.amount)
  
  emit_signal("stats_updated")

# Take 
func get_stat(attribute):
  return current_stats[attribute]
