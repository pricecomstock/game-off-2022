extends Control
class_name LetterView

onready var letter_text_label : Label = $Paper/MarginContainer/LetterText

func display_letter(letter: Letter):
  letter_text_label.text = letter.body