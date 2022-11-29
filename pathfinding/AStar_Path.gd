# based off https://www.youtube.com/watch?v=dVNH6mIDksQ
extends Node
class_name AStarPath

onready var astar : AStar2D = AStar2D.new()
onready var visualization = get_node("Visualization")

export var enable_visualization := false
export var enable_diagonal := false
export var visualization_color := Color(1,1,1,0.2)
export(Font) var visualization_font

var used_cells := {}
var path : PoolVector2Array

func ready():
  pass

func reset():
  astar = AStar2D.new()

func initialize(tilemap : TileMap, navigable_cell_indices := []):
  reset()
  _load_tilemap_cells(tilemap, navigable_cell_indices)
  _add_points()
  _connect_points()

func _load_tilemap_cells(tilemap : TileMap, navigable_cell_indices := []):
  for index in navigable_cell_indices:
    var tiles = tilemap.get_used_cells_by_id(index)
    for tile in tiles:
      used_cells[tile] = 0

func create_visualization(cell):
  var rect = ColorRect.new()
  visualization.add_child(rect)
  rect.rect_size = Vector2(8, 8)
  rect.rect_global_position = GameManager.current_game_world.tile_map_ground.map_to_world(cell)
  var label = Label.new()
  rect.add_child(label)
  label.text = "%s,%s" % [cell.x, cell.y]
  label.add_font_override("font", visualization_font)
  label.add_color_override("font_color", Color.black)
  label.align = HALIGN_CENTER

func _add_points():
  for cell in used_cells:
    astar.add_point(id(cell), cell, 1.0)
    if (enable_visualization):
      create_visualization(cell)

func _connect_points():
  # RIGHT, LEFT, UP, DOWN
  var neighbors = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
  var neighbors_diag = [Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1)]
  for cell in used_cells:
    for neighbor in neighbors:
      var next_cell = cell + neighbor
      if used_cells.has(next_cell):
        astar.connect_points(id(cell), id(next_cell), false)
        
    if enable_diagonal:
      for neighbor_diag in neighbors_diag:
        var next_cell = cell + neighbor_diag
        var just_x = cell + Vector2(neighbor_diag.x, 0)
        var just_y = cell + Vector2(0, neighbor_diag.y)
        if used_cells.has(next_cell) and used_cells.has(just_x) and used_cells.has(just_y):
          astar.connect_points(id(cell), id(next_cell), false)

func _calculate_path(start, end):
  path = astar.get_point_path(id(start), id(end))
  path.remove(0)
  return path

# a contor pairing function
func id(point: Vector2):
  var a = point.x
  var b = point.y
  return (a + b) * (a + b + 1) / 2 + b
