extends Area2D


var pressure_plate_d1_pressed : bool = false

@onready var gate2_collision_shape : CollisionShape2D = $"../Gate2/CollisionShape2D"
@onready var gate2_animated_sprite : AnimatedSprite2D = $"../Gate2/AnimatedSprite2D"
@onready var collision_shape = $CollisionShape2D

func _on_body_entered(body) -> void:
	if body.is_in_group("character"):
		position.y += 2
		collision_shape.set_deferred("disabled", true)
		if pressure_plate_d1_pressed:
			gate2_animated_sprite.play()
			gate2_collision_shape.set_deferred("disabled", false)

func _on_pressure_plate_d_1_body_entered(body):
	if body.is_in_group("character"):
		pressure_plate_d1_pressed = true
