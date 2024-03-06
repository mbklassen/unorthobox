extends TileMap

var z_index_changed : bool = false

func _process(_delta) -> void:
	if PlayerManager.is_behind_wall and not z_index_changed:
		z_index = -2
		z_index_changed = true
	elif not PlayerManager.is_behind_wall and z_index_changed:
		z_index = 0
		z_index_changed = false
