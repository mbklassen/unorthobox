extends RigidBody2D

const BOX_PIECE_1_TEXTURE : Texture2D = preload("res://rooms/room_1/interactables/box/textures/box-piece-1.png")

func _ready():
	get_node("Sprite2D").texture = BOX_PIECE_1_TEXTURE
