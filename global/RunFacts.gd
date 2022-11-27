extends Node

var kills := 0

func reset():
  kills = 0

func _ready():
  reset()
  Events.connect("enemy_killed", self, "_on_enemy_killed")

func _on_enemy_killed():
  kills += 1

func dict() -> Dictionary:
  return {
    "kills": kills
  }