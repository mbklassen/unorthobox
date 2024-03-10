extends TextureButton

var button_disabled = false

func _process(_delta):
	if (RoomManager.room_about_to_change or RoomManager.room_changed or RoomManager.entered_new_room) and not button_disabled:
		disabled = true
		button_disabled = true
	elif not RoomManager.room_about_to_change and not RoomManager.room_changed and not RoomManager.entered_new_room and button_disabled:
		disabled = false
		button_disabled = false
