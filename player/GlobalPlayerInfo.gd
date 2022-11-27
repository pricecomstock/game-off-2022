extends Node

var _player = null

func _ready():
  pass

func player_global_position():
  if is_instance_valid(_player):
    return _player.global_position
  
func player_tile_position():
  if is_instance_valid(_player):
    return GameManager.current_game_world.global_position_to_no_border_tile_position(_player.global_position)
