extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

export var speed := 200
export var friction := 0.25
export var jump_strength := 1000
export var double_jump_strength := 800
export var maximum_jumps := 2
export var gravity := 4000
export var falling_gravity := 4000

var _jumps_made := 0
var _velocity := Vector2.ZERO

var _is_falling := false
var _is_jumping := false
var _is_double_jumping := false
var _is_jump_cancelled := false
var _is_idling := false
var _is_running := false


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func update_movement_states() -> void:
  _is_falling = _velocity.y > 0.0 and not is_on_floor()
  _is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
  _is_double_jumping = Input.is_action_just_pressed("jump") and _is_falling
  _is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
  _is_idling = is_on_floor() and is_zero_approx(_velocity.x)
  _is_running = is_on_floor() and not is_zero_approx(_velocity.x)

func apply_gravity(delta) -> void:
  var current_gravity := falling_gravity if _is_falling else gravity
  _velocity.y += current_gravity * delta


func _process(delta):
  update_movement_states()
    
  
  if _is_jumping:
    _jumps_made += 1
    _velocity.y = -jump_strength
  elif _is_double_jumping:
    _jumps_made += 1
    if _jumps_made <= maximum_jumps:
      _velocity.y = -double_jump_strength
  elif _is_jump_cancelled:
    _velocity.y = 0.0
  elif _is_idling:
    _jumps_made = 0
  
  apply_gravity(delta)
      
      
  var target_x_velocity := (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * speed
  _velocity.x += (target_x_velocity - _velocity.x) * friction


  _velocity = move_and_slide(_velocity, UP_DIRECTION)
