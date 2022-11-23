extends Node

signal letters_updated(letters_dict)

var test_letter = preload("res://letters/written/letter1.tres")

var letters_dict : Dictionary = {} setget ,get_letters

var next_letter_id := 1

func _ready():
  clear()

func get_letters() -> Dictionary:
  return letters_dict

func clear():
  letters_dict.clear()
  emit_signal("letters_updated", letters_dict)

func add_letter(letter: Letter):
  var letter_id = next_letter_id
  letters_dict[next_letter_id] = letter
  emit_signal("letters_updated", letters_dict)
  
  var houses = get_tree().get_nodes_in_group("available_houses")
  if houses.size() == 0:
    # if we're out, label all our houses as available for reuse
    for house in get_tree().get_nodes_in_group("houses"):
      house.add_to_group("available_houses")
      
  var spawn_house = houses[randi() % houses.size()] as House
  spawn_house.spawn_recipient(next_letter_id)
      
  next_letter_id += 1

func remove_letter(id: int):
  letters_dict.erase(id)
  emit_signal("letters_updated", letters_dict)

func has_letter(id: int):
  return letters_dict.has(id)

func deliver_letter(id: int):
  remove_letter(id)
  print("delivered letter ", id)
