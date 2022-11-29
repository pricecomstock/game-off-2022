extends Control

export(PackedScene) var letter_seal_scene
export var seal_scale := 1.0

onready var map_texture_rect = get_node("%MapTextureRect")
onready var icons = get_node("%Icons")
onready var letter_seals = get_node("%LetterSeals")
onready var player_icon = get_node("%PlayerIcon")
onready var extraction_icon = get_node("%ExtractionIcon")

func _ready():
  GameManager.connect("world_generated", self, "_on_world_generated")
  Events.connect("recipients_updated", self, "_on_recipients_updated")

func _process(delta):
  player_icon.rect_position = GlobalPlayerInfo.player_minimap_position()

func _on_world_generated():
  var map_texture : ImageTexture = ImageTexture.new()
  map_texture.create_from_image(GameManager.current_game_world.world_image, Image.FORMAT_RGBA8)
  map_texture_rect.texture = map_texture
  extraction_icon.rect_position = GameManager.current_game_world.extraction_tile_minimap_position

func _on_recipients_updated():
  Util.remove_all_children(letter_seals)
  var letters = LetterManager.get_letters()

  var recipients = get_tree().get_nodes_in_group("recipients")
  var recipients_locations_by_letter_id = {}
  for recipient in recipients:
    recipients_locations_by_letter_id[recipient.letter_id] = GameManager.current_game_world.world_pos_to_minimap(recipient.global_position)
  
  for letter_id in letters:
    var seal = letter_seal_scene.instance()
    letter_seals.add_child(seal)
    seal.set_for_letter(letters[letter_id])
    seal.rect_scale = Vector2(seal_scale, seal_scale)
    seal.rect_position = recipients_locations_by_letter_id[letter_id]
    print("seal at ", seal.rect_position)
