extends Control

export var buff : Resource

export var buff_texture : Texture
export var debuff_texture : Texture

onready var icon : TextureRect = get_node("%Icon")
onready var label : Label = get_node("%Label")

func update_display():
  icon.texture = debuff_texture if buff.is_debuff else buff_texture
  label.text = buff._to_string()

func display_buff(p_buff: Buff):
  buff = p_buff
  update_display()
