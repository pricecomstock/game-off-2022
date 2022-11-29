tool
extends Resource
class_name RandomStringPool

export(Array, String) var string_choices = []

export var copy_import_string_to_choices = false setget from_string
export(String, MULTILINE) var import_string

func _init():
  randomize()
  
func pick():
  return string_choices[randi() % string_choices.size()]

func from_string(_button_bool_dummy):
  string_choices.append_array(import_string.split("\n"))