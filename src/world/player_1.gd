extends Node2D


func _init():
	Gameplay.player_1.rival_layer = 2
	add_child(Gameplay.player_1)
	yield(Gameplay.player_1, "ready")
	
	Gameplay.player_1.hurtbox.set_collision_layer_bit(1, true)
	var camera = Gameplay.camera.instance()
	Gameplay.player_1.add_child(camera)
	
	
	camera.set_limits( Gameplay.gamedata.sceneries_list[Gameplay.scenery_id][Gameplay.gamedata.scenery_info.CAMERA_LIMITS])


func _input(event):
	Gameplay.player_1.input_direction = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	Gameplay.player_1.input_jump = Input.is_action_pressed("JUMP")
	Gameplay.player_1.input_bloq = Input.is_action_pressed("BLOQ")
	Gameplay.player_1.input_down = Input.is_action_pressed("DOWM")
	
	if Input.is_action_just_pressed("atk_1"):
		Gameplay.player_1.skills(0)
	
	elif Input.is_action_just_pressed("atk_2"):
		Gameplay.player_1.skills(1)
	
	elif Input.is_action_just_pressed("atk_3"):
		Gameplay.player_1.skills(2)
	
	elif Input.is_action_just_pressed("atk_4"):
		Gameplay.player_1.skills(3)
	
	elif Input.is_action_just_pressed("atk_5"):
		Gameplay.player_1.skills(4)
	
	elif Input.is_action_just_pressed("atk_6"):
		Gameplay.player_1.skills(5)

