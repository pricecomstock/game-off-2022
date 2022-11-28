# based off https://www.youtube.com/watch?v=dVNH6mIDksQ
extends Node
class_name AStarPath

onready var astar : AStar2D = AStar2D.new()

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

func _add_points():
  for cell in used_cells:
    astar.add_point(id(cell), cell, 1.0)

func _connect_points():
  # RIGHT, LEFT, UP, DOWN
  var neighbors = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
  for cell in used_cells:
    for neighbor in neighbors:
      var next_cell = cell + neighbor
      if used_cells.has(next_cell): # TODO convert to dict to optimize
        astar.connect_points(id(cell), id(next_cell), false)

func _calculate_path(start, end):
  print("start, end:", start, end)
  path = astar.get_point_path(id(start), id(end))
  path.remove(0)
  print("path", path)
  return path

# a contor pairing function
func id(point: Vector2):
  var a = point.x
  var b = point.y
  return (a + b) * (a + b + 1) / 2 + b