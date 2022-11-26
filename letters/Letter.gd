extends Resource
class_name Letter

export var body: String
export var color: Color
export var buffs: Array

var symbol := 0
var id := -1

func _init(
  p_body = "",
  p_color = Color.white,
  p_buffs = [],
  p_symbol = 0
):
  color = p_color
  body = p_body
  buffs = p_buffs
  symbol = p_symbol
