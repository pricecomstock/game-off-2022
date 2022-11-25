extends Resource
class_name Letter

export var body: String
export var color: Color
var id := -1

func _init(
  p_body = "",
  p_color = Color.black
):
  color = p_color
  body = p_body
