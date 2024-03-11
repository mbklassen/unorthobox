extends Area2D

@onready var click_down_sound = $ClickDownSound
@onready var character = $"../../Character"
@onready var terrain_tile_map = $"../../TerrainTileMap"
@onready var secret_message_2 = $"../../SecretMessage2"
@onready var click_up_sound = $ClickUpSound

func _on_body_entered(body):
	if body.is_in_group("character"):
		click_down_sound.play()
		z_index = 0
		position.y -= 2
		secret_message_2.visible = true

func _on_body_exited(body):
	if body.is_in_group("character"):
		click_up_sound.play()
		position.y += 2
		z_index = 1
		secret_message_2.visible = false
