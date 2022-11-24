extends Node2D

signal respawn_finished

onready var animation_player : AnimationPlayer = $AnimationPlayer

func show_respawn():
  animation_player.play("Respawn")
  yield(animation_player, "animation_finished")
  emit_signal("respawn_finished")
  queue_free()