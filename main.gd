extends Node2D

func _ready():
	PlayerManager.is_frozen = false
	PlayerManager.is_behind_wall = false
	PlayerManager.is_surprised = false
	PlayerManager.is_confused = false
	
	RoomManager.room_changed = true
	RoomManager.entered_new_room = false
	RoomManager.gravity_reversed = false
	#RoomManager.music_pitch_changed = false

func _on_restart_button_button_up():
	RoomManager.current_room = 0
	get_tree().reload_current_scene()
