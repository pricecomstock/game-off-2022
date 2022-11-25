extends Resource
class_name LetterGenerator

export(Array, String, MULTILINE) var letter_bodies = []
export(Array, Color) var colors = []

func _init():
  randomize()

func generate_letter() -> Letter:
  return Letter.new(
    letter_bodies[randi() % letter_bodies.size()],
    colors[randi() % colors.size()]
  )