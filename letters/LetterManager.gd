extends Node

signal letters_updated(letters_list)

var letters_list : Array = [] setget ,get_letters

func _ready():
	letters_list = []

func get_letters() -> Array:
	return letters_list

func clear():
	letters_list = []
	emit_signal("letters_updated", letters_list)

func add_letter(letter: Letter):
	letters_list.append(letter)
	emit_signal("letters_updated", letters_list)