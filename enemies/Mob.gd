extends KinematicBody2D

signal health_change
signal health_zero

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var movement_timer : Timer = $MovementTimer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
const directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.ZERO]

export var health := 1
export var speed := 100

export var movement_time_range := Vector2(2.0, 4.0)

func _ready():
  rng.randomize()
  add_to_group("enemies")
  movement_timer.set_one_shot(true)
  movement_timer.connect("timeout", self, "set_movement")
  set_movement()

func _physics_process(delta):
  move_and_slide(velocity)

func set_movement():
  var direction = directions[rng.randi_range(0, directions.size()-1)]
  velocity = direction * speed
  movement_timer.start(rng.randf_range(movement_time_range.x, movement_time_range.y))
  

func take_damage(amount: int) -> void:
  animation_player.play('hit')

  health -= amount
  emit_signal("health_change", health)

  if (health <= 0):
    # animation_player.connect("animation_finished", self, "kill")
    emit_signal("health_zero")
    yield(animation_player, "animation_finished")
    kill()


func kill() -> void:
  get_parent().remove_child(self)
