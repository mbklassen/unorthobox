extends Sprite2D

@onready var box = $"../../Interactables/Box"

func _ready():
	position.x = box.position.x
