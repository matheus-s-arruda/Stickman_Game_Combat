extends Node

var _distance : float


onready var hong = get_parent()


func _physics_process(delta):
	_distance = hong.to_local(Gameplay.player_1.global_position).x
	
	if abs(_distance) > 50:
		hong.input_direction = sign(_distance)
	else:
		hong.input_direction = 0
	
	
	
#	if abs(_distance) < 80:
#		hong.skills(0)
	
