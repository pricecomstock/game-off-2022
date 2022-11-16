extends Node2D

class_name Shooter

# export(int, LAYERS_2D_PHYSICS) var projectile_layer := 0
# export(int, LAYERS_2D_PHYSICS) var projectile_mask := 0

export(PackedScene) var projectile

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
