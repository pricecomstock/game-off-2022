extends Node

signal letters_updated(letters_dict)
signal letter_added(letter_id, letter)

export var show_on_add_seconds := 3.0
export(Resource) var letter_generator

var letters_dict : Dictionary = {} setget ,get_letters

var next_letter_id := 1

func _ready():
  clear()
  Events.connect("player_respawned", self, "_on_player_respawned")

func get_letters() -> Dictionary:
  return letters_dict

func clear():
  letters_dict.clear()
  emit_signal("letters_updated", letters_dict)

func add_letter(letter: Letter):
  var letter_id = next_letter_id
  next_letter_id += 1

  letter.id = letter_id
  letters_dict[letter_id] = letter

  emit_signal("letters_updated", letters_dict)
  emit_signal("letter_added", letter_id, letter)
  
  GameManager.temp_pause(show_on_add_seconds)
  yield(GameManager, "unpaused")

      

func add_random_letter():
  var letter = letter_generator.generate_letter()
  add_letter(letter)

func remove_letter(id: int):
  letters_dict.erase(id)
  emit_signal("letters_updated", letters_dict)

func has_letter(id: int):
  return letters_dict.has(id)

func deliver_letter(id: int):
  remove_letter(id)
  print("delivered letter ", id)

func _on_player_respawned(_location):
  add_random_letter()
