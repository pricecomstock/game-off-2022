extends Node2D

export var talk_duration := 3.0
export var talk_delay := 0.0
export(Resource) var string_pool

onready var speech_bubble = get_node("%SpeechBubble")

func _ready():
  speech_bubble.hide()

func _get_configuration_warning():
  if !(string_pool as RandomStringPool):
    return "Add a string pool!"

func talk():
  var tree = get_tree()
  speech_bubble.hide()
  speech_bubble.set_text(string_pool.pick())
  
  yield(tree.create_timer(talk_delay), "timeout")
  speech_bubble.show()
  speech_bubble.reveal_text()
  speech_bubble.set_fade_timer(talk_duration)
