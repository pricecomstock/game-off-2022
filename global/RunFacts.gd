extends Node

var start_time

var kills := 0
var deaths := 0
var deliveries := 0

func reset():
  start_time = Time.get_ticks_msec()

  kills = 0
  deaths = 0
  deliveries = 0

func current_time():
  return (Time.get_ticks_msec() - start_time) * 0.001

func _ready():
  reset()
  Events.connect("enemy_killed", self, "_on_enemy_killed")
  Events.connect("player_death", self, "_on_player_death")
  Events.connect("letter_delivered", self, "_on_letter_delivered")

func _on_enemy_killed():
  kills += 1

func _on_player_death(_location):
  deaths += 1

func _on_letter_delivered():
  print("got letter delivered message")
  deliveries += 1

func dict() -> Dictionary:
  return {
    "time": current_time(),

    "kills": kills,
    "deaths": deaths,
    "deliveries": deliveries
  }