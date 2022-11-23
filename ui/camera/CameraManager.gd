extends Node

# Lets other remote transforms know to stop pushing transform to camera
signal camera_claimed

var camera : Camera2D

func claim_camera():
  emit_signal("camera_claimed")
  return camera