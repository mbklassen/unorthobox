extends Sprite2D

@onready var character_sprite = $"../../BackBufferCopy/AnimatedSprite2D"

func _process(_delta) -> void:
	if PlayerManager.is_surprised and not visible:
		visible = true
	elif not PlayerManager.is_surprised and visible:
		visible = false

func _on_animated_sprite_2d_animation_finished():
	if character_sprite.animation == "front":
		PlayerManager.is_surprised = false
