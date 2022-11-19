extends KinematicBody2D

signal health_change
signal health_zero

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var movement_timer : Timer = $MovementTimer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var velocity = Vector2.ZERO

export var health := 1

func _ready():
  rng.randomize()
  add_to_group("enemies")

func _physics_process(delta):
  move_and_slide(velocity)
  
func take_damage(amount: int) -> void:
  animation_player.play('hit')

  health -= amount
  emit_signal("health_change", health)

  if (health <= 0):
    emit_signal("health_zero")
    yield(animation_player, "animation_finished")
    kill()

func take_knockback(amount, from_location: Vector2):
  var direction = from_location.direction_to(global_position)
  velocity += direction * amount

func kill() -> void:
  get_parent().remove_child(self)