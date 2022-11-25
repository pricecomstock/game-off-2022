extends Control
class_name LetterView

onready var letter_text_label : Label = get_node("%LetterText")
onready var debug_text_label : Label = get_node("%DebugText")

func display_letter(letter: Letter):
  letter_text_label.text = letter.body
  debug_text_label.text = "CONTROL NUMBER: DS-%03d" % letter.id
