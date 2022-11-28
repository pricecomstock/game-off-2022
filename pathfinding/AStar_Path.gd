# based off https://www.youtube.com/watch?v=dVNH6mIDksQ
extends TileMap
class_name AStarPath

onready var astar : AStar2D = AStar2D.new()
onready var used_cells := get_used_cells()

var path : PoolVector2Array

func _ready():
  _add_points()
  _connect_points()

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

func _get_path():
  path = astar.get_point_path()
  path.remove(0)

# a contor pairing function
func id(point: Vector2):
  var a = point.x
  var b = point.y
  return (a + b) * (a + b + 1) / 2 + b