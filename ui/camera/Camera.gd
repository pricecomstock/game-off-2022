# with inspiration from https://shaggydev.com/2022/02/23/screen-shake-godot/

extends Camera2D

export var shake_speed := 30.0
export var shake_magnitude := 30.0
export var shake_decay := 30.0
export var shake_period := 2.0

# Read from different parts of the noise for different axes
const x_noise_read_pos = 0
const y_noise_read_pos = 100

var current_shake_strength := 0.0
var current_noise_position := 0.0

onready var rand = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()

func _ready():
  make_current()

  rand.randomize()
  # Randomize the generated noise
  noise.seed = rand.randi()
  # Period affects how quickly the noise changes values
  noise.period = shake_period

  process_mode = CAMERA2D_PROCESS_IDLE

  Events.connect("player_shoot", self, "apply_camera_shake")

func _process(delta):
  # I'm pretty sure this is framerate dependent because it sort of multiplies delta across frames
  current_shake_strength = lerp(current_shake_strength, 0, shake_decay * delta)
  offset = get_noise_offset(delta)

func get_noise_offset(delta) -> Vector2:
  # move through the noise based on shake_speed
  current_noise_position += shake_speed * delta
  return Vector2(
    noise.get_noise_2d(x_noise_read_pos, current_noise_position) * current_shake_strength,
    noise.get_noise_2d(y_noise_read_pos, current_noise_position) * current_shake_strength
  )

func apply_camera_shake() -> void:
  current_shake_strength = shake_magnitude

func enter_map_mode():
  zoom = Vector2(4,4)
  
func exit_map_mode():
  zoom = Vector2(1,1)

func _unhandled_input(event: InputEvent):
  if (event.is_action_pressed("map")):
    enter_map_mode()
  if (event.is_action_released("map")):
    exit_map_mode()
