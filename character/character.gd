extends CharacterBody2D


const SPEED : float = 200.0
const JUMP_VELOCITY : float = -300.0
const PUSH_FORCE : float = 1200.0

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_enter_door : bool = false
var is_entering_door : bool = false
var is_shocked : bool = false

@onready var gate = $"../Interactables/Gate"
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta) -> void:
	if not is_on_floor() and not is_entering_door and not PlayerManager.is_behind_wall and not is_shocked:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_entering_door and not PlayerManager.is_behind_wall and not is_shocked:
		velocity.y = JUMP_VELOCITY

	var direction : float 
	if not is_entering_door and not is_shocked:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if direction < 0:
				animated_sprite.flip_h = true
			elif direction > 0:
				animated_sprite.flip_h = false
		velocity.x = direction * SPEED
	
	if is_entering_door:
		position.x = move_toward(self.position.x, gate.position.x, (SPEED/10) * delta)
		if position.x == gate.position.x:
			animated_sprite.animation = "back"
			position.y = move_toward(self.position.y, gate.position.y, (SPEED/10) * delta)
			if position.y == gate.position.y:
				z_index = -1
				animated_sprite.animation = "front"
				animated_sprite.play()
				is_entering_door = false
				is_shocked = true
				$Timer.start(1.2)
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().is_in_group("boxes"):
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE * delta)

func _input(event):
	if event.is_action_released("enter_door") and can_enter_door:
		is_entering_door = true

func _on_gate_body_entered(body):
	if body.is_in_group("character"):
		can_enter_door = true

func _on_gate_body_exited(body):
	if body.is_in_group("character"):
		can_enter_door = false

func _on_timer_timeout():
	PlayerManager.is_behind_wall = true
	is_shocked = false
