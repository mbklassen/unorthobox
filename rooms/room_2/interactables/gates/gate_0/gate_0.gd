extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.frame = 6
	$Timer.start(0.6)

func _on_timer_timeout():
	animated_sprite.play_backwards()
