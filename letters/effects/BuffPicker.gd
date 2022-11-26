class_name BuffPicker

var buffs := []
var debuffs := []

func load_buffs():
  var buff_resources = Util.get_file_paths_in_directory("res://letters/effects/buffs")
  for file in buff_resources:
    buffs.append(load(file))
  
  var debuff_resources = Util.get_file_paths_in_directory("res://letters/effects/debuffs")
  for file in debuff_resources:
    debuffs.append(load(file))

func _init():
  randomize()
  load_buffs()

func get_random_set() -> Array:
  var set = []
  set.append(buffs[randi() %buffs.size()])
  set.append(debuffs[randi() %debuffs.size()])

  return set