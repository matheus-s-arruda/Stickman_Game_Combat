extends Stickman

const JUMP_COOLDOWN : float = 3.0
const THROW_COOLDOWN : float = 5.0

var jump_cooldown : float = JUMP_COOLDOWN
var throw_cooldown : float = THROW_COOLDOWN

var _distance_to_target : float
var rival_layer := 1


func _init():
	pass


func _physics_process(delta):
	if throw_cooldown < THROW_COOLDOWN:
		throw_cooldown += delta
	else:
		throw_cooldown = THROW_COOLDOWN
		
	if jump_cooldown < JUMP_COOLDOWN:
		jump_cooldown += delta
	else:
		jump_cooldown = JUMP_COOLDOWN


func automatic_play():
	_distance_to_target = global_position.distance_to(Gameplay.player_1.global_position)
	if Gameplay.player_1.global_position.x > global_position.x:
		input_direction = 1 if _distance_to_target > 60 else 0
	else:
		input_direction = -1 if _distance_to_target > 60 else 0
	
	input_down = false
	input_bloq = false

	if _distance_to_target > 120:
		return
	atack_inputs(2, true)
	if _distance_to_target > 50:
		if _distance_to_target < 70:
			atack_inputs(1)
	else:
		atack_inputs(0)


func skills(_id : int):
	match _id:
		0:
			if _in_air and atk_state != ATK_STATES.CONDITIONAL and jump_cooldown == JUMP_COOLDOWN and motion.y < -50:
				air_atk()
				jump_cooldown = 0.0
			elif  not _in_air:
				atack_inputs(0)
		1:
			if not _in_air:
				atack_inputs(1)
		2:
			if not _in_air and throw_cooldown == THROW_COOLDOWN:
				throw_cooldown = 0.0
				atack_inputs(2, true)


func hitbox(_atk : int):
	match _atk:
		0: #normal punch
			spawn_hitbox([5, Vector2(origin.scale.x * 70, 0)], Vector2(0, -96), Vector2(48, 16), rival_layer)
		1: #hook
			spawn_hitbox([10, Vector2(origin.scale.x * 150, -120), null], Vector2(0, -106), Vector2(32, 60), rival_layer)
		2: #normal kick
			spawn_hitbox([7, Vector2(origin.scale.x * 250, -120)], Vector2(0, -96), Vector2(29, 32), rival_layer)
		3: #down kick
			spawn_hitbox([10, Vector2(origin.scale.x * 200, -100)], Vector2(0, -46), Vector2(48, 30), rival_layer)
		4: #knock out
			spawn_hitbox([20, Vector2(origin.scale.x * 500, -400), null], Vector2(0, -96), Vector2(48, 32), rival_layer)
		5: #especial_1
			spawn_hitbox([30, Vector2(origin.scale.x * -800, -400), true], Vector2(30, -124), Vector2(30, 8), rival_layer)
		6: #chute aereo
			spawn_hitbox([30, Vector2(origin.scale.x * 300, -300), null], Vector2(-100, -15), Vector2(100, 30), rival_layer)
		7: #slide
			spawn_hitbox([10, Vector2(origin.scale.x * 200, -100)], Vector2(0, -10), Vector2(40, 10), rival_layer)


func anim_wait_floor():
	if not _in_air:
		animation.play("atk_jump_contact")
		var new_hit = Gameplay.FX_IMPACT_JUMP.instance()
		origin.add_child(new_hit)


func air_atk():
	atk_state = ATK_STATES.CONDITIONAL
	master_state = MASTER_STATES.ATACK
	animation.play("atk_jump_in")


func set_color(_color : Color):
	loop_set_color(origin, _color)


func loop_set_color(_node, _color):
	if _node.get_child_count() > 0:
		for _c in range(_node.get_child_count()):
			if _node.get_child(_c) is Position2D:
				_node.get_child(_c).color = _color
				loop_set_color(_node.get_child(_c), _color)
	print(_node.get_child_count())

