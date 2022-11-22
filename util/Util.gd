class_name Util

static func remove_all_children(node: Node) -> void:
  for child in node.get_children():
    node.remove_child(child)
    child.queue_free()

static func merge_tile_map(main: TileMap, merging: TileMap, merging_size: Vector2, merging_offset: Vector2 = Vector2.ZERO) -> void:
  var debug : String = ""
  for x in range(merging_size.x):
    for y in range(merging_size.y):
      debug += str(merging.get_cell(x,y))
      main.set_cell(x + merging_offset.x, y + merging_offset.y, merging.get_cell(x,y))
    debug += str("\n")
  
  main.update_bitmask_region()

static func get_file_paths_in_directory(path: String) -> Array:
  var files = []
  var dir = Directory.new()
  dir.open(path)
  dir.list_dir_begin(true)

  var file = dir.get_next()
  while file != '':
      files.append(path + "/" + file)
      file = dir.get_next()

  return files
