extends Node2D


func _init():
	Gameplay.player_1.rival_layer = 2
	add_child(Gameplay.player_1)
	yield(Gameplay.player_1, "ready")
	Gameplay.player_1.hurtbox.set_collision_layer_bit(1, true)
	Gameplay.player_1.add_child(Gameplay.camera.instance())


func _physics_process(delta):
	Gameplay.player_1.input_direction = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	Gameplay.player_1.input_jump = Input.is_action_pressed("JUMP")
	
	Gameplay.player_1.input_bloq = Input.is_action_pressed("BLOQ")
	
	Gameplay.player_1.input_down = Input.is_action_pressed("DOWM")
	
	if Input.is_action_just_pressed("atk_1"):
		Gameplay.player_1.atack_inputs(0)
		
	elif Input.is_action_just_pressed("atk_2"):
		Gameplay.player_1.atack_inputs(1)
	
	elif Input.is_action_just_pressed("atk_3"):
		Gameplay.player_1.atack_inputs(2, true)
