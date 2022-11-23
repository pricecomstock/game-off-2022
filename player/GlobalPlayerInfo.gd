extends Node

var _player = null

func _ready():
  pass

func player_global_position():
  if is_instance_valid(_player):
    return _player.global_position
  
