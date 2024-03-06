extends TileMap

var z_index_changed : bool = false

func _process(_delta) -> void:
	if PlayerManager.is_behind_wall and not z_index_changed:
		visible = true
		z_index = -2
		z_index_changed = true
