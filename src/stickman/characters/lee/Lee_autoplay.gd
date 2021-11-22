extends Node

var _distance : float


onready var lee = get_parent()


func _physics_process(delta):
	_distance = lee.to_local(Gameplay.player_1.global_position).x
	
	lee.input_direction = sign(_distance)
	
	if abs(_distance) < 80:
		lee.skills(0)
	
