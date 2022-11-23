extends Node2D

onready var label : Label = get_node("%BubbleText")

func _ready():
  label.text = "oop"

func set_text(s: String):
  label.text = s
