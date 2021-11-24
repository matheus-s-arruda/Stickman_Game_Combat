extends Stickman

const KICK_COOLDOWN := 3.0
const JUMP_COOLDOWN := 4.0
const THROW_COOLDOWN := 5.0

var jump_cooldown := 0.0
var throw_cooldown := 0.0
var down_kick_cooldown := 0.0

var rival_layer := 1

func _physics_process(delta):
	if throw_cooldown < THROW_COOLDOWN:
		throw_cooldown += delta
	else:
		throw_cooldown = THROW_COOLDOWN
		
	if jump_cooldown < JUMP_COOLDOWN:
		jump_cooldown += delta
	else:
		jump_cooldown = JUMP_COOLDOWN
		
	if down_kick_cooldown < KICK_COOLDOWN:
		down_kick_cooldown += delta
	else:
		down_kick_cooldown = KICK_COOLDOWN


func skills(_id : int):
	match _id:
		0:
			if _in_air and master_state != MASTER_STATES.DAMAGE and master_state != MASTER_STATES.DEAD and atk_state != ATK_STATES.CONDITIONAL and jump_cooldown == JUMP_COOLDOWN and motion.y < -50:
				jump_cooldown = 0.0
				air_atk()
			elif  not _in_air:
				atack_inputs(0)
		1:
			if not _in_air and master_state != MASTER_STATES.DAMAGE and motion_state == MOTION_STATES.IN_DOWN and down_kick_cooldown == KICK_COOLDOWN:
				down_kick_cooldown = 0.0
				down_kick_atk()
			elif  not _in_air:
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


func down_kick_atk():
	atk_state = ATK_STATES.CONDITIONAL
	master_state = MASTER_STATES.ATACK
	animation.play("down_kick_atk")


