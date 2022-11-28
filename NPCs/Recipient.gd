extends StaticBody2D

export var letter_id : int = 1
onready var delivery_detector: Area2D = $DeliveryDetector
onready var seal = get_node("%LetterSeal")

func _ready():
  add_to_group("recipients")
  delivery_detector.connect("area_entered", self, "_on_DeliveryDetector_area_entered")
  var letter = LetterManager.get_letters()[letter_id]
  seal.set_symbol(letter.symbol)
  seal.set_color(letter.color)

  print("i am a recipient and here")
  Events.emit_signal("recipients_updated")

func attempt_letter_delivery():
  print("delivery!")
  var is_deliverable = LetterManager.has_letter(letter_id)
  if (is_deliverable):
    execute_delivery()

func execute_delivery():
  # TODO add animation or speech bubble or something
  LetterManager.deliver_letter(letter_id)
  remove_from_group("recipients")
  Events.emit_signal("recipients_updated")
  Events.emit_signal("letter_delivered")
  queue_free()

func _on_DeliveryDetector_area_entered(area:Area2D):
  attempt_letter_delivery()
