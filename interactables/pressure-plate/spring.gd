extends Area2D

const SPRING_POWER : int = 800

var spring_has_sprung : bool = false

@onready var box = $"../Box"
@onready var pressure_plate = $"../PressurePlate"
@onready var animation_player = $"../../AnimationPlayer"

func _process(_delta):
	if PlayerManager.is_shocked and not spring_has_sprung:
		pressure_plate.visible = false
		box.spring(SPRING_POWER, rotation + PI/2.0)
		animation_player.play("spring")
		spring_has_sprung = true
