extends HBoxContainer

export var separation := 4

func _ready():
  LetterManager.connect("letters_updated", self, "update_letter_display")
  update_letter_display(LetterManager.get_letters())

func clear() -> void:
  Util.remove_all_children(self)

func add_letter_to_display(letter: Letter) -> void:
  var new_node := TextureRect.new()
  new_node.texture = letter.icon
  new_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT;
  new_node.rect_min_size = Vector2(self.rect_size.y, self.rect_size.y)
  self.add_child(new_node)

func update_letter_display(letters_dict: Dictionary):
  clear()

  for letter_id in letters_dict:
    add_letter_to_display(letters_dict[letter_id])

