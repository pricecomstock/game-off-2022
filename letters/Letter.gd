extends Resource
class_name Letter

export var body: String
export var color: Color

func _init(
  p_body = "",
  p_color = Color.black
):
  color = p_color
  body = p_body
