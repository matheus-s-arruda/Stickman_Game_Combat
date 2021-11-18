extends Stickman

onready var shape = $CollisionShape2D


func _init():
	Gameplay.player_1 = self
	
	_hit_data_slide = [
			[15, Vector2(400, -200), null],
			Vector2(0, -24), Vector2(40, 24), 2]
	
	_hit_data_jump = [
			[15, Vector2(100, -50), null],
			Vector2(0, -24), Vector2(40, 24), 2]


func _process(delta):
	if animation.current_animation == "slide" or animation.current_animation == "slide_in":
		set_shape_size(33)
	else:
		set_shape_size(75)


func _physics_process(delta):
	input_direction = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	input_jump = Input.is_action_pressed("JUMP")
	
	input_bloq = Input.is_action_pressed("BLOQ")
	
	input_down = Input.is_action_pressed("DOWM")
	
	if Input.is_action_just_pressed("atk_1"):
		atack_inputs(0)
		
	elif Input.is_action_just_pressed("atk_2"):
		atack_inputs(1)
	
	elif Input.is_action_just_pressed("atk_3"):
		atack_inputs(2, true)


func set_shape_size(size):
	shape.position.y = -size
	shape.shape.extents.y = size


func hitbox(_atk : int):
	match _atk:
		0: #normal punch
			spawn_hitbox([5, Vector2(origin.scale.x * 70, 0)], Vector2(0, -96), Vector2(48, 16), 2)
		1: #hook
			spawn_hitbox([10, Vector2(origin.scale.x * 150, -120)], Vector2(0, -106), Vector2(32, 60), 2)
		2: #normal kick
			spawn_hitbox([7, Vector2(origin.scale.x * 250, -170)], Vector2(0, -96), Vector2(29, 32), 2)
		3: #down kick
			spawn_hitbox([10, Vector2(origin.scale.x * 200, -100)], Vector2(0, -46), Vector2(48, 30), 2)
		4: #knock out
			spawn_hitbox([20, Vector2(origin.scale.x * 500, -400), null], Vector2(0, -96), Vector2(48, 32), 2)
		5: #especial_1, anim sincronia
			spawn_hitbox([30, Vector2(origin.scale.x * -800, -400), true], Vector2(90, -124), Vector2(8, 8), 2)


