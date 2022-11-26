extends Resource
class_name Letter

export var body: String
export var color: Color
export var buffs: Array
var id := -1

func _init(
  p_body = "",
  p_color = Color.black,
  p_buffs = []
):
  color = p_color
  body = p_body
  buffs = p_buffs
