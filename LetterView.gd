extends Control
class_name LetterView

export(PackedScene) var buff_text_scene

onready var letter_text_label : Label = get_node("%LetterText")
onready var debug_text_label : Label = get_node("%DebugText")
onready var buffs_list : VBoxContainer = get_node("%BuffsList")
onready var seal : LetterSeal = get_node("%LetterSeal")

func display_letter(letter: Letter):
  letter_text_label.text = letter.body
  debug_text_label.text = "CONTROL NUMBER: DS-%03d" % letter.id

  seal.set_color(letter.color)
  seal.set_symbol(letter.symbol)

  Util.remove_all_children(buffs_list)
  for buff in letter.buffs:
    var buff_text = buff_text_scene.instance()
    buffs_list.add_child(buff_text)
    buff_text.display_buff(buff)
