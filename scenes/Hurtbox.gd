class_name HurtBox
extends Area2D

# Called when the node enters the scene tree for the first time.
func _init():
  pass
  # collision_layer = 0
  # collision_mask = 2

func _ready() -> void:
  connect("area_entered", self, "_on_area_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# By specifying the type, we get null if the object isn't a HitBox
func _on_area_entered(hitbox: HitBox) -> void:
  
  if hitbox == null:
	  return

  # owner is the root of the scene
  if owner.has_method("take_damage"):
	  owner.take_damage(hitbox.damage)
  
  emit_signal("hit")
  
  # Disables collision later on in the frame update
  # $CollisionShape2D.set_deferred("disabled", true)
