extends Area2D

@onready var wind_rush_sound = $WindRushSound
@onready var landing_thump_sound = $LandingThumpSound

func _on_body_entered(body):
	if body.is_in_group("character"):
		wind_rush_sound.play()

func _on_wind_rush_sound_finished():
	landing_thump_sound.play()
