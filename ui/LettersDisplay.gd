extends HBoxContainer

signal letter_inspected
signal inspection_stopped

export var separation := 4
export(Texture) var letter_icon

func _ready():
  LetterManager.connect("letters_updated", self, "update_letter_display")
  update_letter_display(LetterManager.get_letters())

func clear() -> void:
  Util.remove_all_children(self)

func add_letter_to_display(letter_id: int, letter: Letter) -> void:
  var new_node := TextureRect.new()
  new_node.texture = letter_icon
  new_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT;
  new_node.rect_min_size = Vector2(self.rect_size.y, self.rect_size.y)

  new_node.connect("mouse_entered", self, "inspect_letter", [letter_id])
  new_node.connect("mouse_exited", self, "stop_inspect")

  self.add_child(new_node)

func inspect_letter(id):
  emit_signal("letter_inspected", id)

func stop_inspect():
  emit_signal("inspection_stopped")

func update_letter_display(letters_dict: Dictionary):
  clear()

  for letter_id in letters_dict:
    add_letter_to_display(letter_id, letters_dict[letter_id])

