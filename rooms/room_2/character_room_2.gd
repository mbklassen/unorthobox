extends CharacterBody2D


const SPEED : float = 150.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $BackBufferCopy/AnimatedSprite2D
@onready var circle_transition = $"../CanvasLayer/CircleTransition"

func _ready():
	circle_transition.call_deferred("set_next_animation", false)
	animated_sprite.animation = "front"

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction : float
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		if not animated_sprite.animation == "side":
			animated_sprite.animation = "side"
		if direction < 0:
			animated_sprite.flip_h = true
		elif direction > 0:
			animated_sprite.flip_h = false
	velocity.x = direction * SPEED
	
	move_and_slide()
