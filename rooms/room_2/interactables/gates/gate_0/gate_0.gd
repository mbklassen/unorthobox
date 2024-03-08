extends Node


@onready var animated_sprite = $AnimatedSprite2D
@onready var gate_closing_sound = $GateClosingSound

func _ready():
	animated_sprite.frame = 6
	$Timer.start(1.2)

func _on_timer_timeout():
	animated_sprite.play_backwards()
	gate_closing_sound.play()
