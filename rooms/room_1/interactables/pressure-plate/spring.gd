extends Area2D

const SPRING_POWER : int = 600

var spring_has_sprung : bool = false

@onready var box = $"../Box"
@onready var pressure_plate = $"../PressurePlate"
@onready var animation_player = $"../../AnimationPlayer"
@onready var spring_sound = $SpringSound
@onready var box_smash_sound = $BoxSmashSound

func _process(_delta):
	if PlayerManager.is_frozen and not spring_has_sprung:
		pressure_plate.visible = false
		box.spring(SPRING_POWER, rotation + PI/2.0)
		animation_player.play("spring")
		spring_sound.play()
		spring_has_sprung = true

func _on_box_body_entered(body):
	if body.is_in_group("terrain"):
		box_smash_sound.play()
