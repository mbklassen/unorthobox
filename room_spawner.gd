extends Node2D

const ROOM_1 = preload("res://rooms/room_1.tscn")

func _ready():
	var room = ROOM_1.instantiate()
	add_child(room)
