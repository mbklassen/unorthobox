class_name Box
extends RigidBody2D

const BOX_PIECE : PackedScene = preload("res://rooms/room_1/interactables/box/box_piece.tscn")
const BOX_PIECE_1_TEXTURE : Texture2D = preload("res://rooms/room_1/interactables/box/textures/box-piece-1.png")
const BOX_PIECE_2_TEXTURE : Texture2D = preload("res://rooms/room_1/interactables/box/textures/box-piece-2.png")
const BOX_PIECE_3_TEXTURE : Texture2D = preload("res://rooms/room_1/interactables/box/textures/box-piece-3.png")
const BOX_PIECE_4_TEXTURE : Texture2D = preload("res://rooms/room_1/interactables/box/textures/box-piece-4.png")

@onready var interactables = $".."


func spring(power : float, direction : float) -> void:
	lock_rotation = false
	linear_velocity.x = linear_velocity.x - cos(direction) * power
	linear_velocity.y = -sin(direction) * power


func _on_box_body_entered(body):
	if body.is_in_group("terrain"):
		var box_piece_1 : RigidBody2D = BOX_PIECE.instantiate()
		var box_piece_2 : RigidBody2D = BOX_PIECE.instantiate()
		var box_piece_3 : RigidBody2D = BOX_PIECE.instantiate()
		var box_piece_4 : RigidBody2D = BOX_PIECE.instantiate()
		
		box_piece_1.position = position + Vector2(-28,0)
		box_piece_2.position = position + Vector2(24,1)
		box_piece_3.position = position + Vector2(-12,5)
		box_piece_4.position = position + Vector2(5,4)
		box_piece_1.angular_velocity = 23
		box_piece_2.angular_velocity = 33
		box_piece_3.angular_velocity = -16
		box_piece_4.angular_velocity = -20
		
		box_piece_1.get_node("Sprite2D").texture = BOX_PIECE_1_TEXTURE
		box_piece_2.get_node("Sprite2D").texture = BOX_PIECE_2_TEXTURE
		box_piece_3.get_node("Sprite2D").texture = BOX_PIECE_3_TEXTURE
		box_piece_4.get_node("Sprite2D").texture = BOX_PIECE_4_TEXTURE
		
		interactables.call_deferred("add_child", box_piece_1)
		interactables.call_deferred("add_child", box_piece_2)
		interactables.call_deferred("add_child", box_piece_3)
		interactables.call_deferred("add_child", box_piece_4)
		
		queue_free()
