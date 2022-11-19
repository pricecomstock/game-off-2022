# with inspiration from https://shaggydev.com/2022/02/23/screen-shake-godot/

extends Camera2D

onready var rand = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()

func _ready():
  make_current()

  rand.randomize()
  # Randomize the generated noise
  noise.seed = rand.randi()
  # Period affects how quickly the noise changes values
  noise.period = 2

  process_mode = CAMERA2D_PROCESS_IDLE

func _process(delta):
  pass

func apply_shake():
  pass