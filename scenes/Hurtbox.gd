extends Area2D

signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_body_entered(body):
	emit_signal("hit")
	print("hit")
	
	# Disables collision later on in the frame update
	$CollisionShape2D.set_deferred("disabled", true)
