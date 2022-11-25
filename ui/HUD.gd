extends CanvasLayer

onready var letters_display = get_node("%LettersDisplay")
onready var letter_view : LetterView = get_node("%LetterView")

func _ready():
  letters_display.connect("letter_inspected", self, "_on_letter_inspected")
  letters_display.connect("inspection_stopped", self, "_on_inspection_stopped")
  letter_view.hide()

func _on_letter_inspected(id):
  var letter = LetterManager.get_letters()[id]
  if (!letter):
    print("invalid letter id", id)
    return

  letter_view.display_letter(letter)
  letter_view.show()

func _on_inspection_stopped():
  letter_view.hide()
