extends Resource
class_name Buff

export(Stats.ATTRIBUTES) var attribute := Stats.ATTRIBUTES.PLAYER_SPEED_MULTIPLIER
export(Stats.MOD_MODE) var mod_mode := Stats.MOD_MODE.ADD
export(float) var amount := 0.0

func _ready():
  pass

func _to_string() -> String:
  return "%s %s" % [get_numeric_change_string(), get_attribute_name()]

func get_attribute_name() -> String:
  return Stats.ATTRIBUTES[attribute]

func get_numeric_change_string() -> String:
  match(mod_mode):
    Stats.MOD_MODE.ADD:
      return "%+d" % amount
    Stats.MOD_MODE.MULTIPLY:
      return "+%s%%" % (amount * 100)
    Stats.MOD_MODE.INCREASE_PERCENT:
      return "+%s%%" % amount
    Stats.MOD_MODE.DECREASE_PERCENT:
      return "+%s%%" % amount
    _:
      return String(amount)