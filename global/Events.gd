# https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
extends Node

signal player_extraction
signal player_death(location)
signal player_death_complete(location)

# Details
signal player_shoot

func _ready():
  pass