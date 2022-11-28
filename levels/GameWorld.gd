extends Node2D
class_name GameWorld

export(PackedScene) var test_chunk
export(PackedScene) var water_chunk
export(PackedScene) var player_scene
export(PackedScene) var extraction_scene

export(float) var minimum_extraction_distance = 512.0

export var chunk_size = Vector2(16, 16)
export var world_size = Vector2(4,4)

onready var y_sort : YSort = $YSort
onready var tile_map_ground : TileMap = $TileMapGround
onready var tile_map_world : TileMap = $YSort/TileMapWorld
onready var camera : Camera2D = $Camera2D

var extraction_tile_position = Vector2.ZERO
var random_chunks = []
var original_player_spawn_position : Vector2 = Vector2.ZERO
var world_image : Image

func _ready():
  randomize()
  load_world_chunks()
  LetterManager.connect("letter_added", self, "_on_letter_added")

func _init():
  pass

func generate():
  clear_world_image()
  assemble_random_chunks()

  var err = world_image.save_png("res://tmp/worldmap.png")
  
  spawn_initial_player()
  spawn_extraction()

  GridNavigation.initialize(tile_map_ground, [1])

# This is basically for minimap. Returns the tile position, not counting the world borders
func global_position_to_no_border_tile_position(position: Vector2) -> Vector2:
  return tile_map_ground.world_to_map(position) - chunk_size # add chunk size for border tile

func assemble_random_chunks():
  var total_world_size = world_size + Vector2(2,2)
  for x_chunk_i in range(total_world_size.x):
    for y_chunk_i in range(total_world_size.y):
      var is_border_chunk = x_chunk_i == 0 or y_chunk_i == 0 or x_chunk_i == total_world_size.x - 1 or y_chunk_i == total_world_size.y - 1
      var chunk
      if is_border_chunk:
        chunk = water_chunk.instance()
      else:
        chunk = random_chunks[randi() % random_chunks.size()].instance()

      var chunk_tile_offset := Vector2(x_chunk_i * chunk_size.x, y_chunk_i * chunk_size.y)
      var chunk_world_pixel_offset := tile_map_world.map_to_world(chunk_tile_offset)
      var chunk_tile_map_ground : TileMap = chunk.get_node("TileMapGround") as TileMap
      var chunk_tile_map_world : TileMap = chunk.get_node("TileMapWorld") as TileMap
      var chunk_y_sort = chunk.get_node("YSort");

      Util.merge_tile_map(tile_map_ground, chunk_tile_map_ground, chunk_size, chunk_tile_offset)
      Util.merge_tile_map(tile_map_world, chunk_tile_map_world, chunk_size, chunk_tile_offset)
      if !is_border_chunk:
        write_tile_map_to_world_image(chunk_tile_map_ground, chunk_tile_offset - chunk_size) #subtract chunk size because border

      move_children_to_new_parent(chunk_y_sort, y_sort, chunk_world_pixel_offset)

func clear_world_image():
  world_image = Image.new()
  world_image.create(world_size.x * chunk_size.x, world_size.y * chunk_size.y, false, Image.FORMAT_RGBA8)
  world_image.fill("#ff425bbd")

func write_tile_map_to_world_image(chunk_tile_map: TileMap, chunk_tile_offset: Vector2):
  world_image.lock()
  var bg_color = Color("4884d4")
  var fg_color = Color("82aa28")
  var colors = [bg_color, fg_color]
  for x in chunk_size.x:
    for y in chunk_size.y:
      var tile_index = chunk_tile_map.get_cell(x, y)
      if tile_index < colors.size():
        world_image.set_pixel(chunk_tile_offset.x + x, chunk_tile_offset.y + y, colors[tile_index])
  world_image.unlock()
  
func move_children_to_new_parent(node: Node2D, new_parent: Node2D, position_offset: Vector2 = Vector2.ZERO):
  for entity in node.get_children():
    node.remove_child(entity)
    entity.position = position_offset + entity.position
    new_parent.add_child(entity)

func spawn_initial_player():
  var player_spawn_points = get_tree().get_nodes_in_group("player_spawn_points")
  var player_spawn_point = player_spawn_points[randi() % player_spawn_points.size()]
  
  var player = player_scene.instance()
  player.position = player_spawn_point.position
  original_player_spawn_position = player_spawn_point.position
  y_sort.add_child(player)

  activate_player(player)

func activate_player(player):
  player.initialize()

func spawn_extraction():
  var extraction_spawn_points = get_tree().get_nodes_in_group("player_spawn_points")
  var spawned = false
  
  while not spawned:
    var extraction_spawn_point = extraction_spawn_points[randi() % extraction_spawn_points.size()]
    var distance_to_player_spawn := original_player_spawn_position.distance_to(extraction_spawn_point.position)
    
    if distance_to_player_spawn > minimum_extraction_distance:
      var extraction = extraction_scene.instance()
      extraction.position = extraction_spawn_point.position
      y_sort.add_child(extraction)
      
      extraction_tile_position = global_position_to_no_border_tile_position(extraction.global_position)
      spawned = true

func load_world_chunks():
  var world_chunk_files = Util.get_file_paths_in_directory("res://levels/chunks/random")
  random_chunks = []
  for file in world_chunk_files:
    random_chunks.append(load(file))

func _on_letter_added(letter_id, _letter):
  var houses = get_tree().get_nodes_in_group("available_houses")
  if houses.size() == 0:
    # if we're out, label all our houses as available for reuse
    for house in get_tree().get_nodes_in_group("houses"):
      house.add_to_group("available_houses")
      
  var spawn_house = houses[randi() % houses.size()] as House
  spawn_house.spawn_recipient(letter_id)

