extends Node2D

onready var remote_transform: RemoteTransform2D = $RemoteTransform2D

func _ready():
  print(remote_transform)

func take_camera():
  remote_transform.remote_path = CameraManager.claim_camera().get_path()
  CameraManager.connect("camera_claimed", self, "release_camera", [], CONNECT_ONESHOT)

func release_camera():
  remote_transform.remote_path = ""
