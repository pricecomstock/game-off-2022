extends Node

signal stats_updated

var current_stats

# Creates a dictionary with a value of 1.0 in every stat
func get_base_stats() -> Dictionary:
  var stats = {}
  for attr in Stats.ATTRIBUTES:
    stats[Stats.ATTRIBUTES[attr]] = 1.0
  
  return stats

func _ready():
  reset()
  LetterManager.connect("letters_updated", self, "recalculate_buffs")

func reset():
  current_stats = get_base_stats()

func recalculate_buffs(letters_dict: Dictionary):
  reset()
  for letter in LetterManager.get_letters().values():
    for buff in letter.buffs:
      apply_buff(buff)

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

func _on_letters_updated(letters_dict: Dictionary):
  recalculate_buffs(letters_dict)
