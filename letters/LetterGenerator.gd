extends Resource
class_name LetterGenerator

export(Array, String, MULTILINE) var letter_bodies = []
export(Array, Color) var colors = []

var buff_picker

func _init():
  randomize()
  buff_picker = BuffPicker.new()

func generate_letter() -> Letter:
  return Letter.new(
    letter_bodies[randi() % letter_bodies.size()],
    colors[randi() % colors.size()],
    buff_picker.get_random_set()
  )