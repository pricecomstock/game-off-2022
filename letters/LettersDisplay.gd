extends HBoxContainer

var test_letter = preload("written/letter1.tres")

func _ready():
	LetterManager.connect("letters_updated", self, "update_letter_display")
	update_letter_display(LetterManager.get_letters())
	add_letter_to_display(test_letter)
	add_letter_to_display(test_letter)

func clear() -> void:
	Util.remove_all_children(self)

func add_letter_to_display(letter: Letter) -> void:
	var new_node := TextureRect.new()
	new_node.texture = letter.icon
	new_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT;
	new_node.rect_min_size = Vector2(self.rect_size.y, self.rect_size.y)
	self.add_child(new_node)

func update_letter_display(letters):
	clear()

	# var letters := LetterManager.get_letters()

	for letter in letters:
		add_letter_to_display(letter)

