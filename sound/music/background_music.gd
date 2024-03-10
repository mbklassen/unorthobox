extends AudioStreamPlayer


func _process(_delta):
	if RoomManager.room_about_to_change and playing:
		stop()
	
	if not RoomManager.music_pitch_changed:
		pitch_scale = randf_range(1.05, 1.4)
		play()
		RoomManager.music_pitch_changed = true
		print("music pitch changed")
