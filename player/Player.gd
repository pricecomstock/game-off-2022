extends KinematicBody2D

export var speed := 200
export var friction = 0.1;

export var projectile_speed = 5.0
export var ranged_attack_cooldown_seconds = 1.0

onready var shooter: Shooter = $Shooter
onready var ranged_cooldown_timer: Timer = $RangedAttackCooldown

var _velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
  # Input.mouse_mode = Input.MOUSE_MODE_CONFINED
  ranged_cooldown_timer.set_one_shot(true)
  pass

func process_ranged_attack():
  if (ranged_cooldown_timer.time_left > 0):
    return

  # TODO test
  var shoot_direction_stick = Vector2(
    Input.get_action_strength("aim_shoot_right") - Input.get_action_strength("aim_shoot_left"),
    Input.get_action_strength("aim_shoot_down") - Input.get_action_strength("aim_shoot_up")
  ).normalized()

  if Input.is_action_pressed("attack"):
    var shoot_direction_mouse = global_position.direction_to(get_global_mouse_position()).normalized()
    shooter.shoot(shoot_direction_mouse * projectile_speed)
    ranged_cooldown_timer.start(ranged_attack_cooldown_seconds)
  elif shoot_direction_stick.length() > 0:
    shooter.shoot(shoot_direction_stick * projectile_speed)
    ranged_cooldown_timer.start(ranged_attack_cooldown_seconds)


func _process(delta):
  process_ranged_attack()


func _physics_process(delta):
  var direction := Vector2(
    Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
    Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
  ).normalized()


  var target_velocity = direction * speed
  _velocity += (target_velocity - _velocity) * friction
  _velocity = move_and_slide(_velocity)
