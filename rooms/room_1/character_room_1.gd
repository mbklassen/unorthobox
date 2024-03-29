extends CharacterBody2D


const SPEED : float = 140.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_enter_gate : bool = false
var can_enter_gate_2 : bool = false
var is_entering_gate : bool = false
var is_entering_gate_2 : bool = false
var wall_phase_timer_started : bool = false
var wait_timer_started : bool = false
var shift_sprite_set : bool = false
var confused_emote_played : bool = false

var direction : float

@onready var gate = $"../Interactables/Gate"
@onready var animated_sprite = $BackBufferCopy/AnimatedSprite2D
@onready var terrain_invisible_colliders = $"../TerrainTileMap/InvisibleColliders"
@onready var input_sprite_space = $"../InputSprites/Space"
@onready var jump_prompt_trigger = $"../InputSprites/JumpPromptTrigger"
@onready var gate_2 = $"../Interactables/Gate2"
@onready var wind_rush_sound = $"../TerrainTileMap/DungeonEntrance/WindRushSound"


func _ready():
	animated_sprite.animation = "front"

func _physics_process(delta) -> void:
	if not is_on_floor() and not is_entering_gate and not is_entering_gate_2 and not PlayerManager.is_frozen:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_gate and not is_entering_gate_2 and not PlayerManager.is_frozen and not PlayerManager.is_locked:
		velocity.y = JUMP_VELOCITY
		if input_sprite_space.visible == true:
			input_sprite_space.visible = false
	
	if not is_entering_gate and not is_entering_gate_2 and not PlayerManager.is_frozen and not PlayerManager.is_locked:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if not animated_sprite.animation == "side":
				animated_sprite.animation = "side"
			if direction < 0:
				animated_sprite.flip_h = true
			elif direction > 0:
				animated_sprite.flip_h = false
		velocity.x = direction * SPEED
		
	if is_entering_gate:
		enter_gate(gate)
		if position.y == gate.position.y + 14 and not wall_phase_timer_started:
			terrain_invisible_colliders.get_node("CollisionShapeInvisibleFloor").disabled = false
			terrain_invisible_colliders.get_node("CollisionShapeInvisibleWall").disabled = false
			PlayerManager.is_frozen = true
			z_index = -1
			animated_sprite.animation = "front"
			animated_sprite.play()
			PlayerManager.is_surprised = true
			is_entering_gate = false
			$WallPhaseTimer.start(3.2)
			wall_phase_timer_started = true
	
	if is_entering_gate_2:
		enter_gate(gate_2)
		if position.y == gate_2.position.y + 14 and not wait_timer_started:
			$WaitTimer.start(0.5)
			wait_timer_started = true
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().is_in_group("boxes"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE * delta)

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
	
func _input(event) -> void:
	if event.is_action_released("enter_gate") and is_on_floor():
		velocity.x = 0
		if can_enter_gate:
			can_enter_gate = false
			is_entering_gate = true
		if can_enter_gate_2:
			can_enter_gate_2 = false
			is_entering_gate_2 = true
	elif event.is_action_released("face_forward") and not direction and not PlayerManager.is_frozen and not PlayerManager.is_locked:
		animated_sprite.animation = "front"
		animated_sprite.stop()
		
func _on_gate_body_entered(body) -> void:
	if body.is_in_group("character"):
		can_enter_gate = true
			
func _on_gate_body_exited(body) -> void:
	if body.is_in_group("character"):
		can_enter_gate = false

func _on_jump_prompt_trigger_body_entered(body):
	if body.is_in_group("character"):
		input_sprite_space.visible = true
		jump_prompt_trigger.set_deferred("monitoring", false)

func _on_dungeon_entrance_body_entered(body):
	if body.is_in_group("character"):
		wind_rush_sound.play()
		#Turn on collisions with world
		set_collision_mask_value(1, true)
		#Turn on collisions with items
		set_collision_mask_value(3, true)
		z_index = 2
		PlayerManager.is_behind_wall = false
		animated_sprite.animation = "front"
		PlayerManager.is_surprised = true
		PlayerManager.is_locked = true
		animated_sprite.speed_scale = 2
		animated_sprite.play()
		$EmoteTimer.start(1)
		
func _on_emote_trigger_body_entered(body):
	if body.is_in_group("character") and not confused_emote_played:
		PlayerManager.is_confused = true
		confused_emote_played = true
		$EmoteTimer.start(1)

func _on_wall_phase_timer_timeout():
	PlayerManager.is_behind_wall = true
	PlayerManager.is_frozen = false
	#Turn off collisions with world
	set_collision_mask_value(1, false)
	#Turn off collisions with items
	set_collision_mask_value(3, false)
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

func _on_emote_timer_timeout():
	PlayerManager.is_confused = false
	PlayerManager.is_surprised = false
	PlayerManager.is_locked = false
	

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
	RoomManager.current_room = 2
	RoomManager.room_changed = true
