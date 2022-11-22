extends Node2D

var direction := Vector2.ZERO
var speed := 0.0
var lifetime_seconds := 4.0

onready var life_timer := $BulletLifeTimer
onready var impact_detector := $ImpactDetector

func _ready():
  # stops projectile from following player transform
  set_as_toplevel(true)

  look_at(position + direction)

  life_timer.connect("timeout", self, "queue_free")
  life_timer.start(lifetime_seconds)

  impact_detector.connect("body_entered", self, "_on_impact")


func _physics_process(delta):
  position += direction * speed * delta

func _on_impact(_body: Node) -> void:
  queue_free()
