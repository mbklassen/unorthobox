extends Node2D

const ROOM_1 : PackedScene = preload("res://rooms/room_1.tscn")

func _ready():
	var room : Node2D = ROOM_1.instantiate()
	add_child(room)
