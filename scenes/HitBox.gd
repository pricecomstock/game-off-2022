class_name HitBox
extends Area2D

export var damage:= 1
export var knockback_force := 20

func _init() -> void:
  pass

func disable():
  monitorable = false

func enable():
  monitorable = true