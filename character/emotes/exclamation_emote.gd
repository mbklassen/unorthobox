extends Sprite2D

var emote_sound_played : bool = false

@onready var character_sprite = $"../../BackBufferCopy/AnimatedSprite2D"
@onready var surprised_emote_sound = $SurprisedEmoteSound

func _process(_delta) -> void:
	if PlayerManager.is_surprised and not visible and not emote_sound_played:
		visible = true
		surprised_emote_sound.play()
		emote_sound_played = true
	elif not PlayerManager.is_surprised and visible:
		visible = false
		emote_sound_played = false

func _on_animated_sprite_2d_animation_finished():
	if character_sprite.animation == "front":
		PlayerManager.is_surprised = false
