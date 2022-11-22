extends Node2D
# class_name GameWorld

export(PackedScene) var test_chunk
export(PackedScene) var water_chunk
export(PackedScene) var player_scene

export var chunk_size = Vector2(16, 16)
export var world_size = Vector2(4,4)

onready var y_sort : YSort = $YSort
onready var tile_map_ground : TileMap = $TileMapGround
onready var tile_map_world : TileMap = $YSort/TileMapWorld

var random_chunks = []

func _ready():
  randomize()
  load_world_chunks()

func _init():
  pass

func generate():
  var total_world_size = world_size + Vector2(2,2)
  for x_chunk_i in range(total_world_size.x):
    for y_chunk_i in range(total_world_size.y):
      var chunk
      if x_chunk_i == 0 or y_chunk_i == 0 or x_chunk_i == total_world_size.x - 1 or y_chunk_i == total_world_size.y - 1: # border chunk
        chunk = water_chunk.instance()
      else:
        chunk = random_chunks[randi() % random_chunks.size()].instance()

      var chunk_offset := Vector2(x_chunk_i * chunk_size.x, y_chunk_i * chunk_size.y)
      var chunk_world_offset := tile_map_world.map_to_world(chunk_offset)
      var chunk_tile_map_ground : TileMap = chunk.get_node("TileMapGround") as TileMap
      var chunk_tile_map_world : TileMap = chunk.get_node("TileMapWorld") as TileMap
      var chunk_y_sort = chunk.get_node("YSort");

      Util.merge_tile_map(tile_map_ground, chunk_tile_map_ground, chunk_size, chunk_offset)
      Util.merge_tile_map(tile_map_world, chunk_tile_map_world, chunk_size, chunk_offset)

      # TODO fix this lol
      for entity in chunk_y_sort.get_children():
        chunk_y_sort.remove_child(entity)
        entity.position = chunk_world_offset + entity.position
        y_sort.add_child(entity)
  
  var player = player_scene.instance()
  var map_pos := tile_map_world.map_to_world(Vector2(45, 45))
  player.position = map_pos
  y_sort.add_child(player)

func _unhandled_input(event: InputEvent):
  if (event.is_action_pressed("menu")):
    GameManager.change_state(GameManager.GameState.MENU)


func load_world_chunks():
  var world_chunk_files = Util.get_file_paths_in_directory("res://levels/chunks/random")
  random_chunks = []
  for file in world_chunk_files:
    random_chunks.append(load(file))
