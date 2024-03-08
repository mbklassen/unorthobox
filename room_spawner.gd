extends Node2D

const ROOM_0 : PackedScene = preload("res://rooms/room_0/room_0.tscn")
const ROOM_1 : PackedScene = preload("res://rooms/room_1/room_1.tscn")
const ROOM_2 : PackedScene = preload("res://rooms/room_2/room_2.tscn")

var room : Node2D
var old_room : Node2D

func _ready() -> void:
	room = ROOM_0.instantiate()
	add_child(room)

func _process(_delta):
	if RoomManager.room_changed:
		old_room = get_child(0)
		old_room.queue_free()
		remove_child(old_room)
		match RoomManager.current_room:
			1:
				room = ROOM_1.instantiate()
				add_child(room)
			2: 
				room = ROOM_2.instantiate()
				add_child(room)
		RoomManager.room_changed = false
		RoomManager.entered_new_room = true
	#pass
