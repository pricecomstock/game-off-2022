extends Node

var _player = null

func _ready():
  pass

func player_global_position():
  if is_instance_valid(_player):
    return _player.global_position
  else:
    return Vector2.ZERO
    
func player_tile_position():
  if is_instance_valid(_player):
    return GameManager.current_game_world.world_pos_to_tile(_player.global_position)
  else:
    return Vector2.ZERO
    
func player_minimap_position():
  if is_instance_valid(_player):
    return GameManager.current_game_world.world_pos_to_minimap(_player.global_position)
  else:
    return Vector2.ZERO
