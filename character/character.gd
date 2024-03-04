extends CharacterBody2D


const SPEED : float = 200.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_enter_door : bool = false
var is_entering_door : bool = false
var timer_started : bool = false

@onready var gate = $"../Interactables/Gate"
@onready var animated_sprite = $AnimatedSprite2D
#@onready var pressure_plate = $"../Interactables/PressurePlate"
#@onready var pressure_plate_collision_shape = $"../Interactables/PressurePlate/CollisionShape2D"

func _physics_process(delta) -> void:
	if not is_on_floor() and not is_entering_door and not PlayerManager.is_shocked and not PlayerManager.is_behind_wall:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_door and not PlayerManager.is_shocked and not PlayerManager.is_behind_wall:
		velocity.y = JUMP_VELOCITY

	var direction : float 
	if not is_entering_door:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if direction < 0:
				animated_sprite.flip_h = true
			elif direction > 0:
				animated_sprite.flip_h = false
		velocity.x = direction * SPEED
	
	if is_entering_door:
		position.x = move_toward(position.x, gate.position.x, (SPEED/6) * delta)
		if position.x < gate.position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		if position.x == gate.position.x:
			animated_sprite.animation = "back"
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
			position.y = move_toward(position.y, gate.position.y + 8, (SPEED/6) * delta)
			if position.y == gate.position.y + 8 and not timer_started:
				PlayerManager.is_shocked = true
				z_index = -1
				animated_sprite.animation = "front"
				animated_sprite.play()
				is_entering_door = false
				$Timer2.start(1.2)
				timer_started = true
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().is_in_group("boxes"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE * delta)

func _input(event) -> void:
	if event.is_action_released("enter_door") and can_enter_door:
		is_entering_door = true

func _on_gate_body_entered(body) -> void:
	if body.is_in_group("character"):
		can_enter_door = true

func _on_gate_body_exited(body) -> void:
	if body.is_in_group("character"):
		can_enter_door = false

func _on_timer_2_timeout() -> void:
	PlayerManager.is_behind_wall = true
	PlayerManager.is_shocked = false
