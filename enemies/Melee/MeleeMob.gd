extends "res://enemies/BaseMob.gd"

onready var hitbox = $HitBox

func _ready():
  randomize()
  movement_timer.set_one_shot(true)

func kill():
  hitbox.disable()
  .kill()
