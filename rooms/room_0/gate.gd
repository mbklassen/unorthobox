extends Area2D

@onready var gate_opening_sound = $GateOpeningSound

func _on_pressure_plate_body_entered(_body):
	gate_opening_sound.play()
