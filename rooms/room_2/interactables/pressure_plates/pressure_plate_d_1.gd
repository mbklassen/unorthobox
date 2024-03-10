extends Area2D


var pressure_plate_d2_pressed : bool = false
var clicked_back_up : bool = false

@onready var collision_shape = $CollisionShape2D
@onready var character = $"../../Character"
@onready var click_down_sound = $ClickDownSound
@onready var character_animated_sprite = $"../../Character/BackBufferCopy/AnimatedSprite2D"


func _on_body_entered(body) -> void:
	if body.is_in_group("character"):
		click_down_sound.play()
		position.y += 2
		collision_shape.set_deferred("disabled", true)
		if pressure_plate_d2_pressed and not clicked_back_up:
			character.set_collision_mask_value(1, false)
		if clicked_back_up:
			character.set_collision_mask_value(1, true)
			RoomManager.gravity_reversed = true
		
func _on_pressure_plate_d_2_body_entered(body):
	if body.is_in_group("character"):
		pressure_plate_d2_pressed = true

func _on_pressure_plate_d_3_body_entered(body):
	if body.is_in_group("character"):
		position.y -= 2
		collision_shape.set_deferred("disabled", false)
		clicked_back_up = true
		
