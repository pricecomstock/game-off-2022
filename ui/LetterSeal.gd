extends Control
class_name LetterSeal

export var symbol_texture_atlas : AtlasTexture
export var symbol_size : Vector2 = Vector2(24, 24)

onready var symbol : TextureRect = get_node("%Symbol")

var symbol_count := 1

func _ready():
  randomize()
  symbol_count = floor(symbol_texture_atlas.get_size().x / symbol_size.x)

func random_symbol_index() -> int:
  return randi() % symbol_count

func set_symbol(index: int):
  var cropped_texture = symbol_texture_atlas.duplicate()
  cropped_texture.set_region(Rect2(
    Vector2(symbol_size.x * index, 0),
    symbol_size
  ))
  symbol.set_texture(cropped_texture)

func set_color(color: Color):
  modulate = color

func set_for_letter(letter: Letter):
  set_color(letter.color)
  set_symbol(letter.symbol)
