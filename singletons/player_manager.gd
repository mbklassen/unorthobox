extends Node

# Locks movement and essentially disables gravity on player
var is_frozen : bool = false
# True when player is behind the background wall
var is_behind_wall : bool = false
# True when surprised emoting
var is_surprised : bool = false
# True when confused emoting
var is_confused : bool = false
# Just locks movement
var is_locked : bool = false
