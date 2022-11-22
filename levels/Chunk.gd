extends Node2D
class_name Chunk

var tile_map_ground : TileMap
var tile_map_world : TileMap

func _init():
  tile_map_ground = $TileMapGround
  tile_map_world = $YSort/TileMapWorld
