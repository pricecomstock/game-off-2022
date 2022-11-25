extends Resource
class_name Letter

# TODO different icons per letter probably

export var body: String
export var icon: Texture

func _init(
	p_body = "",
	p_icon = null
):
	icon = p_icon
	body = p_body