extends Node2D


func _init():
	add_child(Gameplay.player_2)
	#Gameplay.player_2.add_child( Gameplay.gamedata.get_stick_data( Gameplay.player_2_id, Gameplay.gamedata.stick_info.AUTOPLAY).instance())
	yield(Gameplay.player_2, "ready")
	
	var _color = Gameplay.gamedata.get_stick_data(Gameplay.player_2_id, Gameplay.gamedata.stick_info.COLORS)
	Gameplay.player_2.set_color(_color[ Gameplay.player_2_color] )
	Gameplay.player_2.hurtbox.set_collision_layer_bit(2, true)
	Gameplay.player_2.origin.scale.x = -1


