extends Area2D

@onready var landing_thump_sound = $LandingThumpSound

func _on_wind_rush_sound_finished():
	landing_thump_sound.play()
