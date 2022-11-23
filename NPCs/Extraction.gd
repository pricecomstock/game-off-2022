extends StaticBody2D

onready var player_detector : Area2D = $PlayerDetector

func _ready():
  player_detector.connect("area_entered", self, "_on_PlayerDetector_area_entered")

func _on_PlayerDetector_area_entered(_area: Area2D):
  Events.emit_signal("player_extraction")
  print("Extraction!")