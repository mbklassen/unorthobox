extends Control

var fade_out_animation_played : bool = false
var fade_in_animation_played : bool = false

@onready var animation_texture : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.speed_scale = 1.5
	if RoomManager.current_room == 0:
		visible = false

func _process(_delta):
	if RoomManager.room_about_to_change and not fade_out_animation_played:
		animation_player.play("fade_out")
		fade_out_animation_played = true
		fade_in_animation_played = false
		visible = true
		
	elif RoomManager.entered_new_room and RoomManager.current_room != 0 and not fade_in_animation_played:
		animation_player.play("fade_in")
		fade_in_animation_played = true
		RoomManager.entered_new_room = false
		fade_out_animation_played = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		visible = false
