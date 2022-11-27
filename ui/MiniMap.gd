extends Control

onready var map_texture_rect = get_node("%MapTextureRect")

func _ready():
  GameManager.connect("world_generated", self, "_on_world_generated")

func _on_world_generated():
  var map_texture : ImageTexture = ImageTexture.new()
  map_texture.create_from_image(GameManager.current_game_world.world_image, Image.FORMAT_RGBA8)
  map_texture_rect.texture = map_texture