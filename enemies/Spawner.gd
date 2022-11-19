extends Node2D

export(PackedScene) var entity_to_spawn
export var spawn_time := 5.0
export var auto_spawn := false

onready var spawn_timer : Timer = $SpawnTimer
onready var player_detector : Area2D = $PlayerSafetyDetector

func _ready():
  add_to_group("spawners")
  add_to_group("active_spawners")
  hide() # don't show in game
  spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
  spawn_timer.start(spawn_time)

  player_detector.connect("area_entered", self, "_on_player_nearby")
  player_detector.connect("area_exited", self, "_on_player_not_nearby")

func _on_spawn_timer_timeout():
  if (auto_spawn):
    spawn()

func spawn():
  var entity = entity_to_spawn.instance()

  entity.position = position
  get_tree().current_scene.add_child(entity)

func _on_player_nearby(_area: Area2D):
  print("disabling spawner")
  remove_from_group("active_spawners")
  
func _on_player_not_nearby(_area: Area2D):
  print("re-enabling spawner")
  add_to_group("active_spawners")