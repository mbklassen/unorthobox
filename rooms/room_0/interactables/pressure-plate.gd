extends Area2D


@onready var gate_collision_shape : CollisionShape2D = $"../Gate/CollisionShape2D"
@onready var gate_animated_sprite : AnimatedSprite2D = $"../Gate/AnimatedSprite2D"
@onready var collision_shape = $CollisionShape2D
@onready var click_down_sound = $ClickDownSound

func _on_body_entered(body) -> void:
	if body.is_in_group("character"):
		position.y += 3
		click_down_sound.play()
		gate_animated_sprite.play()
		collision_shape.set_deferred("disabled", true)
		gate_collision_shape.set_deferred("disabled", false)
