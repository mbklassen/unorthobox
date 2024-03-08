extends Area2D

var press_count : int = 0

@onready var gate_collision_shape : CollisionShape2D = $"../Gate/CollisionShape2D"
@onready var gate_animated_sprite : AnimatedSprite2D = $"../Gate/AnimatedSprite2D"
@onready var collision_shape = $CollisionShape2D
@onready var click_down_sound = $ClickDownSound
@onready var click_up_sound = $ClickUpSound
@onready var gate_opening_sound = $"../Gate/GateOpeningSound"
@onready var gate_closing_sound = $"../Gate/GateClosingSound"


func _process(_delta):
	if PlayerManager.is_behind_wall:
		$CollisionShape2D.disabled = true

func _on_body_entered(body) -> void:
	if (body.is_in_group("character") or body.is_in_group("boxes")):
		if press_count == 0:
			position.y += 3
			click_down_sound.play()
			gate_animated_sprite.play()
			if gate_closing_sound.playing:
				gate_closing_sound.stop()
			gate_opening_sound.play()
			gate_collision_shape.set_deferred("disabled", false)
		press_count += 1
		
func _on_body_exited(body) -> void:
	if (body.is_in_group("character") or body.is_in_group("boxes")) and press_count > 0:
		press_count -= 1
		if press_count == 0:
			if PlayerManager.is_frozen:
				$Timer.start(1.4)
			else:
				position.y -= 3
				click_up_sound.play()
				if gate_opening_sound.playing:
					gate_opening_sound.stop()
				gate_closing_sound.play()
				gate_animated_sprite.play_backwards()
				gate_collision_shape.set_deferred("disabled", true)

func _on_timer_timeout():
	gate_closing_sound.play()
	gate_animated_sprite.play_backwards()
	gate_collision_shape.set_deferred("disabled", true)
