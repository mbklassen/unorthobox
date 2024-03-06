extends Sprite2D


func _process(_delta) -> void:
	if PlayerManager.is_confused and not visible:
		visible = true
	elif not PlayerManager.is_confused and visible:
		visible = false
