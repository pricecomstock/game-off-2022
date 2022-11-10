extends Resource
class_name Letter

# TODO different icons per letter probably
export var recipient_name: String
export var body: String
export var sender: String
export var icon: Texture

func _init(
	p_recipient_name = "",
	p_body = "",
	p_sender = "",
	p_icon = null
):
	icon = p_icon
	recipient_name = p_recipient_name
	body = p_body
	sender = p_sender