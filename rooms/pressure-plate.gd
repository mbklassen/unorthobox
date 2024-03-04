extends Area2D

var press_count : int = 0

@onready var gate_collision_shape : CollisionShape2D = $"../Gate/CollisionShape2D"
@onready var gate_animated_sprite : AnimatedSprite2D = $"../Gate/AnimatedSprite2D"
@onready var collision_shape = $CollisionShape2D

func _process(_delta):
	if PlayerManager.is_behind_wall:
		$CollisionShape2D.disabled = true

func _on_body_entered(body) -> void:
	if (body.is_in_group("character") or body.is_in_group("boxes")):
		if press_count == 0:
			position.y += 3
			gate_animated_sprite.play()
			gate_collision_shape.set_deferred("disabled", false)
			#gate_collision_shape.disabled = false
		press_count += 1
		
func _on_body_exited(body) -> void:
	if (body.is_in_group("character") or body.is_in_group("boxes")) and press_count > 0:
		press_count -= 1
		if press_count == 0:
			if PlayerManager.is_shocked:
				print("we are shocked")
				$Timer.start(0.8)
			else:
				print("changing position")
				position.y -= 3
				gate_animated_sprite.play_backwards()
				gate_collision_shape.set_deferred("disabled", true)

func _on_timer_timeout():
	gate_animated_sprite.play_backwards()
	gate_collision_shape.set_deferred("disabled", true)
