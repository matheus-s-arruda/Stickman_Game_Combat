extends Node2D




func _init():
	Gameplay.player_2.set_collision_layer_bit(2, true)
	add_child(Gameplay.player_2)





