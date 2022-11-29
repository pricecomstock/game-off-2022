extends Node2D

export(PackedScene) var entity_to_autospawn
export var spawn_time := 5.0
export var auto_spawn := false

onready var spawn_timer : Timer = $SpawnTimer
onready var player_safety_detector : Area2D = $PlayerSafetyDetector
onready var player_nearby_detector : Area2D = $PlayerNearbyDetector
onready var sprite : Sprite = $Sprite

# func _process(delta):
#   if is_in_group("active_spawners"):
#     sprite.visible = true
#   else:
#     sprite.visible = false

func _ready():
  add_to_group("spawners")
  hide() # don't show in game
  spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
  spawn_timer.start(spawn_time)

  player_safety_detector.connect("area_entered", self, "_on_player_close")
  player_safety_detector.connect("area_exited", self, "_on_player_not_close")
  player_nearby_detector.connect("area_entered", self, "_on_player_nearby")
  player_nearby_detector.connect("area_exited", self, "_on_player_not_nearby")

func _on_spawn_timer_timeout():
  if (auto_spawn and entity_to_autospawn):
    print("autospawn")
    spawn(entity_to_autospawn)

func spawn(entity_to_spawn: PackedScene):
  var entity = entity_to_spawn.instance()
  print("spawning ", entity)
  get_parent().add_child(entity)

  entity.global_position = global_position

# Player is too close and we need to disable spawner
func _on_player_close(_area: Area2D):
  remove_from_group("active_spawners")
  
func _on_player_not_close(_area: Area2D):
  add_to_group("active_spawners")

# Player is somewhat nearby so this spawner should be active
func _on_player_nearby(_area: Area2D):
  add_to_group("active_spawners")
    
func _on_player_not_nearby(_area: Area2D):
  remove_from_group("active_spawners")
