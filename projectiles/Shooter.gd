extends Node2D

class_name Shooter

onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

export(PackedScene) var projectile
export(AudioStream) var sound_effect

func _ready():
  audio_player.set_stream(sound_effect)

func shoot(velocity: Vector2):
  var new_projectile = projectile.instance()
  # new_projectile.collision_layer = projectile_layer
  # new_projectile.collision_mask = projectile_mask
  new_projectile.direction = velocity.normalized()
  new_projectile.speed = velocity.length()
  new_projectile.set_global_position(global_position)
  
  add_child(new_projectile)

func _get_configuration_warning():
  if projectile == null:
    return "Need a projectile!"

  return ""
