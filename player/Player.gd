extends KinematicBody2D

# TODO Maybe player emits a signal when they are activated so that previous player instances
# TODO can deactivate themselves

signal health_change
signal health_zero


export var health := 1
export var speed := 200
export var friction = 0.1;

export var projectile_speed = 5.0
export var ranged_attack_cooldown_seconds = 1.0

export var spawn_invulnerability_seconds = 1.0;

export(PackedScene) var corpse_scene
export(PackedScene) var respawn_scene

var can_take_damage = true
var controls_enabled := true

onready var shooter: Shooter = $Shooter
onready var ranged_cooldown_timer: Timer = $RangedAttackCooldown
onready var remote_transform: RemoteTransform2D = $RemoteTransform2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

var _velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
  GlobalPlayerInfo._player = self
  ranged_cooldown_timer.set_one_shot(true)
  _velocity = Vector2.ZERO

func process_ranged_attack():
  if (ranged_cooldown_timer.time_left > 0):
    return

  # TODO test
  var shoot_direction_stick = Vector2(
    Input.get_action_strength("aim_shoot_right") - Input.get_action_strength("aim_shoot_left"),
    Input.get_action_strength("aim_shoot_down") - Input.get_action_strength("aim_shoot_up")
  ).normalized()

  var shot = false

  if Input.is_action_pressed("attack"):
    var shoot_direction_mouse = global_position.direction_to(get_global_mouse_position()).normalized()
    shooter.shoot(shoot_direction_mouse * projectile_speed)
    shot = true
  elif shoot_direction_stick.length() > 0:
    shooter.shoot(shoot_direction_stick * projectile_speed)
    shot = true
  
  if shot:
    Events.emit_signal("player_shoot")
    ranged_cooldown_timer.start(ranged_attack_cooldown_seconds)

func _physics_process(delta):
  if !controls_enabled:
    return

  process_ranged_attack()
  var direction := Vector2(
    Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
    Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
  ).normalized()


  var target_velocity = direction * speed
  _velocity += (target_velocity - _velocity) * friction
  _velocity = move_and_slide(_velocity)

func take_damage(amount: int) -> void:
  if !can_take_damage:
    return

  # animation_player.play('hit')

  health -= amount
  emit_signal("health_change", health)

  if (health <= 0):
    emit_signal("health_zero")
    # yield(animation_player, "animation_finished")
    kill()


func take_knockback(amount, from_location: Vector2):
  if !can_take_damage:
    return
  var direction = from_location.direction_to(global_position)
  _velocity += direction * amount

func take_camera():
  remote_transform.remote_path = CameraManager.claim_camera().get_path()
  CameraManager.connect("camera_claimed", self, "release_camera", [], CONNECT_ONESHOT)

func release_camera():
  remote_transform.remote_path = ""

func freeze():
  controls_enabled = false

func unfreeze():
  controls_enabled = true

func kill() -> void:
  controls_enabled = false
  Events.emit_signal("player_death", self.global_position)

  print("dying")

  # TODO figure out how to use animation_state here
  # animation_state.travel("Death")
  # yield(animation_tree, "animation_finished")
  animation_player.play("Death")
  yield(animation_player, "animation_finished")
  
  # Set up corpse
  var corpse = corpse_scene.instance()
  corpse.global_position = global_position
  get_parent().add_child(corpse)

  respawn()

func respawn():
  hide()
  var respawn_player = respawn_scene.instance()
  # TODO calculate new respawn location
  respawn_player.position = position
  get_parent().add_child(respawn_player)
  respawn_player.show_respawn()

  set_invulnerability_until(respawn_player, "respawn_finished")
  
  yield(respawn_player, "respawn_finished")
  show()
  controls_enabled = true

  set_invulnerability_timer(spawn_invulnerability_seconds)

func set_invulnerability_timer(seconds: float):
  set_invulnerability_until(get_tree().create_timer(seconds), "timeout")

func set_invulnerability_until(obj, signal_name: String):
  can_take_damage = false
  yield(obj, signal_name)
  can_take_damage = true
