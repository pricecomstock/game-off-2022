# https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
extends Node

signal player_extraction
signal player_death(location)
signal player_respawned(location)
signal recipients_updated
signal letter_delivered

# Details
signal player_shoot
signal player_health_change(amount)
signal player_max_health_change(amount)

signal enemy_killed

# UI
signal confirm_button_clicked

func _ready():
  pass