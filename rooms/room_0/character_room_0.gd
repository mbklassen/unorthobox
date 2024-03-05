extends CharacterBody2D


const SPEED : float = 150.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_enter_gate : bool = false
var is_entering_gate : bool = false
var timer_started : bool = false

@onready var gate = $"../Interactables/Gate"
@onready var animated_sprite = $BackBufferCopy/AnimatedSprite2D
	
func _physics_process(delta) -> void:
	if not is_on_floor() and not is_entering_gate:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_gate:
		velocity.y = JUMP_VELOCITY
	
	var direction : float
	if not is_entering_gate:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if direction < 0 and not PlayerManager.is_behind_wall:
				animated_sprite.flip_h = true
			elif direction > 0 and not PlayerManager.is_behind_wall:
				animated_sprite.flip_h = false
		velocity.x = direction * SPEED
		
	if is_entering_gate:
		position.x = move_toward(position.x, gate.position.x, (SPEED/6) * delta)
		if position.x < gate.position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		if position.x == gate.position.x:
			animated_sprite.animation = "back"
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
			position.y = move_toward(position.y, gate.position.y + 14, (SPEED/6) * delta)
			if position.y == gate.position.y + 14 and not timer_started:
				print("we made it")
				$Timer.start(1)
				timer_started = true
		
	move_and_slide()

func _input(event) -> void:
	if event.is_action_released("enter_gate") and can_enter_gate:
		can_enter_gate = false
		is_entering_gate = true

func _on_gate_body_entered(body) -> void:
	if body.is_in_group("character"):
		can_enter_gate = true
			
func _on_gate_body_exited(body) -> void:
	if body.is_in_group("character"):
		can_enter_gate = false
		
func _on_timer_timeout():
	RoomManager.room_changed = true
	RoomManager.current_room = 1
