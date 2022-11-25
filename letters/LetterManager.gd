extends Node

signal letters_updated(letters_dict)
signal letter_added(letter_id, letter)

var test_letter = preload("res://letters/written/letter1.tres")

var letters_dict : Dictionary = {} setget ,get_letters

var next_letter_id := 1

func _ready():
  clear()
  add_letter(test_letter)

func get_letters() -> Dictionary:
  return letters_dict

func clear():
  letters_dict.clear()
  emit_signal("letters_updated", letters_dict)

func add_letter(letter: Letter):
  var letter_id = next_letter_id
  letters_dict[next_letter_id] = letter
  emit_signal("letters_updated", letters_dict)
  emit_signal("letter_added", letter_id, letter)
      
  next_letter_id += 1

func remove_letter(id: int):
  letters_dict.erase(id)
  emit_signal("letters_updated", letters_dict)

func has_letter(id: int):
  return letters_dict.has(id)

func deliver_letter(id: int):
  remove_letter(id)
  print("delivered letter ", id)
