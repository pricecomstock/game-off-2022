extends MarginContainer

var current_health := 2
var max_health := 3

const format_string = "%s/%s"

onready var label = get_node("%Label")
onready var progress : TextureProgress = get_node("%HealthProgress")

# Called when the node enters the scene tree for the first time.
func _ready():
  Events.connect("player_max_health_change", self, "_on_player_max_health_change")
  Events.connect("player_health_change", self, "_on_player_health_change")
  update_healthbar()

func _on_player_max_health_change(new_value: int):
  max_health = new_value
  update_healthbar()

func _on_player_health_change(new_value: int):
  current_health = new_value
  update_healthbar()

func update_healthbar():
  print("progress", progress)
  progress.set_max(max_health)
  progress.set_value(current_health)
  label.text = format_string % [max(current_health, 0), max_health]
