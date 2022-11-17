extends Node2D

export(PackedScene) var entity_to_spawn
export var spawn_time := 5.0
export var auto_spawn := false

onready var spawn_timer : Timer = $SpawnTimer

func _ready():
  add_to_group("spawners")
  hide() # don't show in game
  spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
  spawn_timer.start(spawn_time)

func _on_spawn_timer_timeout():
  if (auto_spawn):
    spawn()

func spawn():
  var entity = entity_to_spawn.instance()

  entity.position = position
  get_tree().current_scene.add_child(entity)

