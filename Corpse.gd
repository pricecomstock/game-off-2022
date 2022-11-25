extends Node2D

export var talk_delay := 1.0
export var talk_duration := 2.0

onready var remote_transform: RemoteTransform2D = $RemoteTransform2D
onready var speech_bubble = $SpeechBubble

func _ready():
  print(remote_transform)
  speech_bubble.hide()

  get_tree().create_timer(talk_delay).connect("timeout", self, "talk")

func take_camera():
  remote_transform.remote_path = CameraManager.claim_camera().get_path()
  CameraManager.connect("camera_claimed", self, "release_camera", [], CONNECT_ONESHOT)

func release_camera():
  remote_transform.remote_path = ""

func talk():
  speech_bubble.show()
  speech_bubble.reveal_text()
  speech_bubble.set_fade_timer(talk_duration)
