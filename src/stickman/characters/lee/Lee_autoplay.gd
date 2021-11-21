extends Node


var _distance_to_target : float

onready var lee = get_parent()


func _physics_process(delta):
	_distance_to_target = lee.global_position.distance_to(Gameplay.player_1.global_position)
	
	if Gameplay.player_1.global_position.x > lee.global_position.x:
		lee.input_direction = 1 if _distance_to_target > 60 else 0
	else:
		lee.input_direction = -1 if _distance_to_target > 60 else 0
	
	lee.input_down = false
	lee.input_bloq = false
