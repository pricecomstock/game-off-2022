extends "res://enemies/BaseMob.gd"

export var movement_refresh_seconds := 2.0
export var movement_refresh_variance := 0.5
export var speed := 100

func _ready():
  var timer_offset := (randf() - 1.0) * movement_refresh_variance

  set_movement()
  movement_timer.set_one_shot(false)
  movement_timer.set_wait_time(movement_refresh_seconds + timer_offset)
  movement_timer.connect("timeout", self, "set_movement")
  movement_timer.start()



func set_movement():
  var player_direction = global_position.direction_to(GlobalPlayerInfo.player_global_position())
  velocity = player_direction * speed