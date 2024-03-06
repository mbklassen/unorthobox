extends Area2D

func _process(_delta):
	if PlayerManager.is_behind_wall:
		$ShaderMasks.visible = true
	elif not PlayerManager.is_behind_wall:
		$ShaderMasks.visible = false
