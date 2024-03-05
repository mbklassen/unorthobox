extends Area2D

func _process(_delta):
	if PlayerManager.is_behind_wall:
		$ShaderMask.visible = true
		$ShaderMask2.visible = true
		$ShaderMask3.visible = true
	elif not PlayerManager.is_behind_wall:
		$ShaderMask.visible = false
		$ShaderMask2.visible = false
		$ShaderMask3.visible = false
