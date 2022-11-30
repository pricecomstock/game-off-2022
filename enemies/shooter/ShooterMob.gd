extends BaseMob

export var shots_per_second = 1.0
export var projectile_speed = 300

export var player_catchup_distance_threshold := 200

onready var shooter : Shooter = $Shooter
onready var attack_timer : Timer

func _ready():
  attack_timer = Timer.new()
  add_child(attack_timer)
  attack_timer.set_one_shot(true)
  attack_timer.set_autostart(false)
  attack_timer.wait_time = 10

func calculate_player_nearby_behavior():
  velocity = Vector2.ZERO
  if (attack_timer.time_left <= 0.0):
    print("distance to player ", get_distance_to_player())
    shoot_at_player()
    attack_timer.start(1.0 / (shots_per_second * GlobalStats.get_stat(Stats.ATTRIBUTES.ENEMY_RATE_OF_FIRE_MULTIPLIER)))

func shoot_at_player():
  shooter.shoot(get_direction_to_player() * projectile_speed)
  

func determine_move_mode():
  var distance_to_player = get_distance_to_player()
  if (current_move_state == MovementState.DEAD || current_move_state == MovementState.FLEEING):
    return
  elif distance_to_player > player_catchup_distance_threshold:
    change_move_state(MovementState.NAVIGATING_TO_PLAYER)
  elif distance_to_player < player_nearby_threshold && has_line_of_sight_to_player:
    change_move_state(MovementState.PLAYER_NEARBY)
  else:
    .determine_move_mode()
