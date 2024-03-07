extends Control

@onready var animation_texture : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	animation_texture.visible = false

func set_next_animation(fading_out : bool):
	if fading_out:
		animation_player.queue("fade_out")
	else:
		animation_player.play("fade_in")
