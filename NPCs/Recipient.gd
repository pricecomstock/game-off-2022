extends StaticBody2D

export var letter_id : int = 1
onready var delivery_detector: Area2D = $DeliveryDetector

func _ready():
  print("dd", delivery_detector)
  delivery_detector.connect("area_entered", self, "_on_DeliveryDetector_area_entered")
  pass

func attempt_letter_delivery():
  print("delivery!")
  var is_deliverable = LetterManager.has_letter(letter_id)
  if (is_deliverable):
    LetterManager.deliver_letter(letter_id)

func _on_DeliveryDetector_area_entered(area:Area2D):
	attempt_letter_delivery()
