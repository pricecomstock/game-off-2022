extends Node2D

# Start with text hidden and play reveal animation immediately when node is instantiated
export var auto_reveal := true
export var auto_fade := true
export var fade_after_seconds := 3.0

onready var label : Label = get_node("%BubbleText")
onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
  if (auto_reveal):
    reveal_text()
  else:
    label.set_percent_visible(1.0)

  if (auto_fade):
    set_fade_timer(fade_after_seconds)

func set_fade_timer(seconds):
  get_tree().create_timer(seconds).connect("timeout", self, "hide", [], CONNECT_ONESHOT)

func set_text(s: String):
  label.text = s

func reveal_text():
  animation_player.play("RevealText")
