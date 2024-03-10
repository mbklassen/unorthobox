extends Sprite2D

var emote_sound_played : bool = false
@onready var confused_emote_sound = $ConfusedEmoteSound

func _process(_delta) -> void:
	if PlayerManager.is_confused and not visible and not emote_sound_played:
		visible = true
		confused_emote_sound.play()
		emote_sound_played = true
	elif not PlayerManager.is_confused and visible and emote_sound_played:
		visible = false
		emote_sound_played = false
