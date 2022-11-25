# https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
extends Node

signal player_extraction
signal player_death(location)
signal player_death_complete(location)

# Details
signal player_shoot
signal player_health_change(amount)
signal player_max_health_change(amount)

func _ready():
  pass