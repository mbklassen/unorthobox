extends Area2D

@onready var secret_message = $"../../SecretMessage"
@onready var collision_shape = $CollisionShape2D
@onready var collision_shape_upper = $"../SecretTrigger2/CollisionShape2D"

func _on_secret_trigger_2_body_entered(body):
	if body.is_in_group("character"):
		secret_message.visible = true
		collision_shape.set_deferred("disabled", true)
		collision_shape_upper.set_deferred("disabled", true)
