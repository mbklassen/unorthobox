extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var click_down_sound = $ClickDownSound
@onready var character = $"../../Character"
@onready var terrain_tile_map = $"../../TerrainTileMap"
@onready var landing_thump_sound = $LandingThumpSound
@onready var wind_rush_sound = $WindRushSound

func _on_body_entered(body):
	if body.is_in_group("character"):
		click_down_sound.play()
		z_index = 0
		position.x -= 2
		collision_shape.set_deferred("disabled", true)
		character.set_collision_mask_value(1, false)
		character.set_collision_mask_value(3, false)
		RoomManager.gravity_reversed = false
		wind_rush_sound.play()

func _on_wind_rush_sound_finished():
	landing_thump_sound.play()
