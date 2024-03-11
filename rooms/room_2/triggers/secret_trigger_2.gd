extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var collision_shape_lower = $"../SecretTrigger/CollisionShape2D"
@onready var secret_message = $"../../SecretMessage"

func _on_secret_trigger_body_entered(body):
	if body.is_in_group("character"):
		secret_message.visible = true
		collision_shape.set_deferred("disabled", true)
		collision_shape_lower.set_deferred("disabled", true)
