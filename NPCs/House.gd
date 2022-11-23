extends StaticBody2D
class_name House

export(PackedScene) var recipient_scene
onready var recipient_spawn_point = $RecipientSpawnPoint

func _ready():
  add_to_group("houses")
  add_to_group("available_houses")

func spawn_recipient(id: int):
  var recipient = recipient_scene.instance()
  recipient.letter_id = id
  add_child(recipient)
  recipient.position = recipient_spawn_point.position