extends Node2D

func _ready():
	PlayerManager.is_frozen = false
	PlayerManager.is_behind_wall = false
	PlayerManager.is_surprised = false
	PlayerManager.is_confused = false
	
	RoomManager.current_room = 0
	RoomManager.room_changed = false

func _on_restart_button_button_up():
	get_tree().reload_current_scene()
