extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var gate0_animated_sprite = $"../Gate0/AnimatedSprite2D"
@onready var gate0_collision_shape = $"../Gate0/CollisionShape2D"

func _on_body_entered(body):
	if body.is_in_group("character"):
		position.y += 2
		collision_shape.set_deferred("disabled", true)
		gate0_animated_sprite.play()
		gate0_collision_shape.set_deferred("disabled", false)
