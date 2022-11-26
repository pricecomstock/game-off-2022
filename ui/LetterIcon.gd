extends Control

onready var seal = get_node("%LetterSeal")

func display_letter(letter: Letter):
  seal.set_color(letter.color)
  seal.set_symbol(letter.symbol)
