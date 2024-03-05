extends CharacterBody2D


const SPEED : float = 150.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_enter_gate : bool = false
var is_entering_gate : bool = false
var timer_started : bool = false
var shift_sprite_set : bool = false

@onready var gate = $"../Interactables/Gate"
@onready var animated_sprite = $BackBufferCopy/AnimatedSprite2D
@onready var terrain_tile_map_floor = $"../TerrainTileMap/InvisibleFloor"
	
func _physics_process(delta) -> void:
	if not is_on_floor() and not is_entering_gate and not PlayerManager.is_shocked:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_gate and not PlayerManager.is_shocked:
		velocity.y = JUMP_VELOCITY
	
	var direction : float
	if not is_entering_gate and not PlayerManager.is_shocked:
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
				terrain_tile_map_floor.get_node("CollisionShapeInvisibleFloor").disabled = false
				PlayerManager.is_shocked = true
				z_index = -1
				animated_sprite.animation = "front"
				animated_sprite.play()
				is_entering_gate = false
				$Timer.start(3.2)
				timer_started = true
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().is_in_group("boxes"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE * delta)

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
			
func _on_timer_timeout() -> void:
	PlayerManager.is_behind_wall = true
	PlayerManager.is_shocked = false
	#Turn off collisions with world
	set_collision_mask_value(1, false)
	#Turn off collisions with items
	set_collision_mask_value(3, false)
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
