extends Area2D


var pressure_plate_d1_pressed : bool = false

@onready var collision_shape = $CollisionShape2D
@onready var character = $"../../Character"

func _on_body_entered(body) -> void:
	if body.is_in_group("character"):
		position.y += 2
		collision_shape.set_deferred("disabled", true)
		if pressure_plate_d1_pressed:
			character.set_collision_mask_value(1, false)

func _on_pressure_plate_d_1_body_entered(body):
	if body.is_in_group("character"):
		pressure_plate_d1_pressed = true
