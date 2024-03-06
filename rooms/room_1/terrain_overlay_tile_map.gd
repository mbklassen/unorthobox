extends TileMap


func _process(_delta) -> void:
	if PlayerManager.is_behind_wall and not visible:
		visible = true
