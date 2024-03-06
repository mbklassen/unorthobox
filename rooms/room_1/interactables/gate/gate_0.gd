extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$Timer.start(0.6)

func _on_timer_timeout():
	animated_sprite.play_backwards()
