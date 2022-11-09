extends Node2D

signal health_change
signal health_zero

onready var animation_player := $AnimationPlayer

export var health := 1

func take_damage(amount: int) -> void:
	animation_player.play('hit')

	print("hit for ", amount)
	
	health -= amount
	emit_signal("health_change", health)

	if (health <= 0):
		# animation_player.connect("animation_finished", self, "kill")
		emit_signal("health_zero")
		yield(animation_player, "animation_finished")
		kill()


func kill() -> void:
	print("killing")
	get_parent().remove_child(self)
