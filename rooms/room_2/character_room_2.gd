extends CharacterBody2D


const SPEED : float = 140.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var confused_emote_1_played : bool = false
var surprised_emote_played : bool = false
var upside_down : bool = false
var gravity_direction : int = 1
var can_enter_gate_2 : bool = false
var is_entering_gate_2 : bool = false
var wait_timer_started : bool = false

var direction : float

@onready var animated_sprite = $BackBufferCopy/AnimatedSprite2D
@onready var pressure_plate_d_1 = $"../Interactables/PressurePlateD1"
@onready var gravity_change_sound = $"../Interactables/PressurePlateD1/GravityChangeSound"
@onready var gate_2 = $"../Interactables/Gate2"

func _ready():
	animated_sprite.animation = "front"

func _physics_process(delta) -> void:
	if RoomManager.gravity_reversed and not upside_down:
		up_direction = Vector2(0,1)
		rotation_degrees = 180
		gravity_direction = -1
		upside_down = true
		gravity_change_sound.play()
		
	if not RoomManager.gravity_reversed and upside_down:
		up_direction = Vector2(0,-1)
		rotation_degrees = 0
		gravity_direction = 1
		upside_down = false
		gravity_change_sound.play()
		
	if not is_on_floor() and not is_entering_gate_2:
		velocity.y += gravity * gravity_direction * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_gate_2:
		velocity.y = JUMP_VELOCITY * gravity_direction
	
	if not is_entering_gate_2:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if not animated_sprite.animation == "side":
				animated_sprite.animation = "side"
			if direction < 0 and not RoomManager.gravity_reversed:
				animated_sprite.flip_h = true
			elif direction < 0 and RoomManager.gravity_reversed:
				animated_sprite.flip_h = false
			elif direction > 0 and not RoomManager.gravity_reversed:
				animated_sprite.flip_h = false
			elif direction > 0 and RoomManager.gravity_reversed:
				animated_sprite.flip_h = true
		velocity.x = direction * SPEED
	
	if is_entering_gate_2:
		enter_gate(gate_2)
		if position.y == gate_2.position.y + 14 and not wait_timer_started:
			$WaitTimer.start(0.5)
			wait_timer_started = true
	
	move_and_slide()

func enter_gate(gate_i) -> void:
	if position.x < gate_i.position.x:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	if position.x == gate_i.position.x:
		animated_sprite.animation = "back"
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		position.y = move_toward(position.y, gate_i.position.y + 14, (SPEED/200))
	else:
		position.x = move_toward(position.x, gate_i.position.x, (SPEED/200))

func _input(event):
	if event.is_action_released("face_forward") and velocity.x == 0 and not PlayerManager.is_frozen and not PlayerManager.is_locked:
		animated_sprite.animation = "front"
		animated_sprite.stop()
	if event.is_action_released("enter_gate") and can_enter_gate_2 and is_on_floor():
		velocity.x = 0
		can_enter_gate_2 = false
		is_entering_gate_2 = true

func _on_emote_trigger_body_entered(body):
	if body.is_in_group("character") and not confused_emote_1_played:
		PlayerManager.is_confused = true
		confused_emote_1_played = true
		$EmoteTimer.start(1)

func _on_emote_trigger_1_body_entered(body):
	if body.is_in_group("character") and not surprised_emote_played:
		PlayerManager.is_surprised = true
		$EmoteTimer.start(1)

func _on_emote_timer_timeout():
	PlayerManager.is_confused = false
	PlayerManager.is_surprised = false

func _on_gate_2_body_entered(body):
	if body.is_in_group("character"):
		can_enter_gate_2 = true
	
func _on_gate_2_body_exited(body):
	if body.is_in_group("character"):
		can_enter_gate_2 = false

func _on_wait_timer_timeout():
	RoomManager.room_about_to_change = true
	$RoomChangeTimer.start(0.9)

func _on_room_change_timer_timeout():
	RoomManager.room_about_to_change = false
	RoomManager.current_room = 3
	RoomManager.room_changed = true
