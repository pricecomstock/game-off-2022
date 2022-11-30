extends KinematicBody2D
class_name BaseMob

signal health_change
signal health_zero

export var speed := 100
export var friction := 20.0
export var flee_time := 4.0
export var spawn_budget_cost := 1
# The distance at which a path destination is considered reached and we move onto the next one
export var path_destination_threshold := 4.0

export var visualize_path := false

# The distance at which the player is considered nearby and we no longer need to pathfind
export var player_nearby_threshold := 100.0
export var player_nearby_check_seconds := 0.3

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var movement_timer : Timer = $MovementTimer
onready var player_line_of_walk_detector : RayCast2D = get_node("%PlayerLineOfWalkDetector")
onready var player_line_of_sight_detector : RayCast2D = get_node("%PlayerLineOfSightDetector")
onready var path_recalc_cooldown_timer = $PathRecalcCooldownTimer

var path_visualization : Line2D
var has_line_of_walk_to_player = false
var has_line_of_sight_to_player = false

enum MovementState { PLAYER_NEARBY, NAVIGATING_TO_PLAYER, FLEEING, ATTACKING, DEAD }

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var velocity := Vector2.ZERO

# for handling things like knockback
var extra_velocity := Vector2.ZERO
var current_move_state = MovementState.PLAYER_NEARBY
var determine_move_mode_timer : Timer

var path : PoolVector2Array = []
var path_current_destination_index := 0
var path_current_travel_direction := Vector2.ZERO

export var health := 1

func _ready():
  rng.randomize()
  add_to_group("enemies")
  Events.connect("player_death", self, "_on_player_death")
  
  determine_move_mode_timer = Timer.new()
  add_child(determine_move_mode_timer)
  determine_move_mode_timer.set_one_shot(false)
  determine_move_mode_timer.wait_time = player_nearby_check_seconds
  determine_move_mode_timer.connect("timeout", self, "determine_move_mode")
  determine_move_mode_timer.start()

  path_visualization = Line2D.new()

  determine_move_mode()

func _physics_process(delta):
  los_check()
  calculate_behavior_for_state()
  calculate_extra_velocity(delta)
  move_and_slide(velocity + extra_velocity)

func los_check():
  var player_offset = GlobalPlayerInfo.player_global_position() - global_position

  player_line_of_walk_detector.cast_to = player_offset
  player_line_of_walk_detector.force_raycast_update()
  has_line_of_walk_to_player = !player_line_of_walk_detector.is_colliding()

  player_line_of_sight_detector.cast_to = player_offset
  player_line_of_sight_detector.force_raycast_update()
  has_line_of_sight_to_player = !player_line_of_sight_detector.is_colliding()

func calculate_extra_velocity(delta):
  extra_velocity = extra_velocity.move_toward(Vector2.ZERO, delta * friction)

# this should have something for each state
func calculate_behavior_for_state():
  match current_move_state:
    MovementState.PLAYER_NEARBY:
      calculate_player_nearby_behavior()
    MovementState.NAVIGATING_TO_PLAYER:
      calculate_navigate_to_player_behavior()
    MovementState.FLEEING:
      calculate_flee_behavior()
    MovementState.ATTACKING:
      calculate_attack_behavior()
    MovementState.DEAD:
      pass

func calculate_player_nearby_behavior():
  velocity = get_direction_to_player() * speed

func calculate_navigate_to_player_behavior():
  set_velocity_towards_next_nav_waypoint()

func calculate_flee_behavior():
  velocity = -get_direction_to_player() * speed

func calculate_attack_behavior():
  velocity = Vector2.ZERO

func change_move_state(new_state):
  var previous_move_state = current_move_state
  current_move_state = new_state
  # print("State change: %s -> %s" % [previous_move_state, current_move_state])

  # set up new state
  match current_move_state:
    MovementState.FLEEING:
      # Revert to previous state after a bit
      delay_change_move_state(previous_move_state, flee_time)
    MovementState.NAVIGATING_TO_PLAYER:
      calculate_path_to_player()
    _:
      pass
  
  # cleanup previous state
  match previous_move_state:
    _:
      pass

func delay_change_move_state(state: int, delay: float):
  yield(get_tree().create_timer(delay), "timeout")
  change_move_state(state)

# Can override to change state change behavior. Probably an if statement and then fall back to this
func determine_move_mode():
  var previous_move_state = current_move_state
  match previous_move_state: # don't automatically change out of these states
    MovementState.DEAD, MovementState.FLEEING:
        return
    _:
      if get_distance_to_player() < player_nearby_threshold && has_line_of_walk_to_player:
        change_move_state(MovementState.PLAYER_NEARBY)
      else:
        change_move_state(MovementState.NAVIGATING_TO_PLAYER)
  
          

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
  extra_velocity += direction * amount

func kill() -> void:
  velocity = Vector2.ZERO
  change_move_state(MovementState.DEAD)
  animation_player.play("Death")
  Events.emit_signal("enemy_killed")
  yield(animation_player, "animation_finished")
  get_parent().remove_child(self)
  queue_free()


func get_distance_to_player() -> float:
  return global_position.distance_to(GlobalPlayerInfo.player_global_position())

func get_direction_to_player() -> Vector2:
  return global_position.direction_to(GlobalPlayerInfo.player_global_position())

func get_tile_position() -> Vector2:
  return GameManager.current_game_world.tile_map_ground.world_to_map(global_position) 

func calculate_path_to_player():
  path_recalc_cooldown_timer.start()
  var player_tile_position = GlobalPlayerInfo.player_tile_position()
  var mob_tile_position = get_tile_position()
  path_current_destination_index = 0
  path = GridNavigation._calculate_path(mob_tile_position, player_tile_position)
  if (path.size() == 0):
    print("path from %s to %s of size %s" % [mob_tile_position, player_tile_position, path.size()])
  if visualize_path:
    path_visualization.width = 2
    path_visualization.default_color = Color.red
    path_visualization.points = path
    

func set_velocity_towards_next_nav_waypoint():
  # TODO maybe skip ahead until there isn't LOS? might be hard
  if (path.size() == 0):
    return
    
  if (path_current_destination_index >= path.size()):
    print("past end of path")
    change_move_state(MovementState.PLAYER_NEARBY)
    return
  
  var path_current_destination : Vector2 = path[path_current_destination_index]
  var path_current_destination_world : Vector2 = GameManager.current_game_world.tile_pos_to_world(path_current_destination)

  # Reached destination, set to next tile
  if (global_position.distance_to(path_current_destination_world) < path_destination_threshold):
    path_current_destination_index += 1

    if (path_current_destination_index >= path.size()):
      return
    else:
      path_current_destination = path[path_current_destination_index]

  path_current_destination_world = GameManager.current_game_world.tile_pos_to_world(path_current_destination)
  path_current_travel_direction = global_position.direction_to(path_current_destination_world)
  velocity = speed * path_current_travel_direction

func _on_player_death(_location: Vector2):
  change_move_state(MovementState.FLEEING)
