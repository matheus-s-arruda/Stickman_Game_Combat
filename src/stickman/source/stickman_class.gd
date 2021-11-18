class_name Stickman
extends KinematicBody2D

const hitbox = preload("res://src/stickman/physics/hitbox.tscn")
const hitbox_free_by_condition = preload("res://src/stickman/physics/hitbox_free_by_condition.tscn")

enum MASTER_STATES {CUTSCENE, MOTION, ATACK, DAMAGE, DEAD}
enum MOTION_STATES {STATELESS, IN_AIR, IN_SLIDE, IN_DOWN}
enum ATK_STATES {STATELESS, IN_BLOQ, ONSLAUGHT,  CONDITIONAL}
enum DMG_STATES {STATELESS, KNOCKBACK}

const SPEED := 800
const GRAVITY := 1176
const JUMP_FORCE := 600
const POSTURE_TIME_RECHARGE := 4.0
const POSTURE_MAX := 25.0
const LIFE_MAX := 100.0

export(NodePath) onready var origin = get_node(origin)
export(NodePath) onready var animation = get_node(animation)
export(Array, Array, String) var _atks
export(String) var _aereo_kick : String
export(Array, String) var _atk_special

var life := LIFE_MAX
var posture := POSTURE_MAX
var motion : Vector2
var hit := [] setget _hited

var input_direction := 0
var input_jump := 0
var input_down := false
var input_bloq := false

var master_state = MASTER_STATES.MOTION
var motion_state = MOTION_STATES.STATELESS
var atk_state = ATK_STATES.STATELESS
var dmg_state = DMG_STATES.STATELESS

var _flag_swap_dir := 0
var _damage_nockback := false
var _posture_recharge := 0.0

var _bloq_break_down = false
var _atk_condition = null
var _combo_anim_list = []
var _combo_await := false
var _combo_count := -1
var _combo_current_atk = -1

var _hitbox_by_condition = null
var _hit_data_jump := []
var _hit_data_slide := []


func _physics_process(delta):
	var speed_target := 0.0
	var speed_target_air := motion.x
	_calc_posture(delta)
	
	motion = move_and_slide(motion, Vector2.UP, true)
	
	if is_on_floor():
		motion.y = 0
		if input_down:
			if abs(motion.x) > 200:
				if motion_state != MOTION_STATES.IN_DOWN:
					motion_state = MOTION_STATES.IN_SLIDE
			else:
				motion_state = MOTION_STATES.IN_DOWN
		else:
			motion_state = MOTION_STATES.STATELESS
	else:
		motion.y += GRAVITY * delta
		if abs(motion.y) > 20:
			motion_state = MOTION_STATES.IN_AIR
			if master_state == MASTER_STATES.DAMAGE:
				_damage_nockback = true
	
	if master_state != MASTER_STATES.DAMAGE:
		_damage_nockback = true
	
	if master_state != MASTER_STATES.ATACK:
		reset_atk_props()
	
	match master_state:
		MASTER_STATES.CUTSCENE:
			return
			
		MASTER_STATES.MOTION:
			_motion_state()
			
		MASTER_STATES.ATACK:
			_atack_state()
			if motion_state != MOTION_STATES.IN_AIR:
				motion.x = lerp(motion.x, 0, 0.15)
			
		MASTER_STATES.DAMAGE:
			if motion_state == MOTION_STATES.IN_AIR:
				dmg_state = DMG_STATES.KNOCKBACK
			else:
				motion.x = lerp(motion.x, 0, 0.1)
			_damaged_state()
			
		MASTER_STATES.DEAD:
			if motion_state != MOTION_STATES.IN_AIR:
				animation.play("die_contact")
				return
	
	match motion_state:
		MOTION_STATES.STATELESS:
			motion.y += input_jump * -JUMP_FORCE
			speed_target = 0
			atk_state = ATK_STATES.IN_BLOQ if input_bloq else ATK_STATES.STATELESS
			if animation.current_animation == "run":
				speed_target = input_direction * SPEED
			if animation.current_animation == "walk":
				speed_target = input_direction * SPEED * 0.18
			
			motion.x = lerp(motion.x, speed_target, 0.2)
			
		MOTION_STATES.IN_SLIDE:
			_atk_condition = 1
			master_state = MASTER_STATES.ATACK
			motion.x = lerp(motion.x, 0, 0.007)
			return
			
		MOTION_STATES.IN_DOWN:
			atk_state = ATK_STATES.IN_BLOQ
			motion.x = lerp(motion.x, input_direction * SPEED, 0.07)
		
		MOTION_STATES.IN_AIR:
			speed_target_air = clamp(speed_target_air -(-input_direction * 100), -SPEED, SPEED)
			motion.x = lerp(motion.x, speed_target_air, 0.2)


func _motion_state():
	if motion_state == MOTION_STATES.IN_AIR:
		origin.scale.x = input_direction if input_direction != 0 else origin.scale.x
		if motion.y > 0:
			animation.play("jump_down")
		else:
			animation.play("jump_up")
	else:
		if animation.current_animation == "jump_up" or animation.current_animation == "jump_down":
			animation.play("jump_contact")
			return
			
		if (animation.current_animation == "jump_contact" or animation.current_animation == "run_stop" or
				animation.current_animation == "slide_in" or animation.current_animation == "slide_out"):
			if (animation.current_animation_length - animation.current_animation_position) > 0.05:
				return
		origin.scale.x = input_direction if input_direction != 0 else origin.scale.x
		
		match motion_state:
			MOTION_STATES.STATELESS:
				if animation.current_animation == "slide" or animation.current_animation == "slide_in":
					animation.play("slide_out")
					return
				
				if _flag_swap_dir != input_direction:
					if _flag_swap_dir == 0:
						animation.play("walk" if atk_state == ATK_STATES.IN_BLOQ else "run")
						
					if input_direction == 0 and animation.current_animation == "run" and abs(motion.x) > 600:
						animation.play("run_stop")
					
					_flag_swap_dir = input_direction
					return
				
				elif input_direction != 0:
					animation.play("walk" if atk_state == ATK_STATES.IN_BLOQ else "run")
					return
				animation.play("idle")
			
			MOTION_STATES.IN_SLIDE:
				if animation.current_animation != "slide":
					if animation.current_animation != "slide_in":
						animation.play("slide_in")
						return
				animation.play("slide")
				
			MOTION_STATES.IN_DOWN:
				if input_direction == 0:
					animation.play("down_idle")
				else:
					animation.play("down_walk")


func _damaged_state():
	if life <= 0.0:
		_die()
	if _damage_nockback and is_on_floor() and animation.current_animation == "damage_2":
		animation.play("damage_2_contact")
	if (animation.current_animation_length - animation.current_animation_position) > 0.05:
		return
	master_state = MASTER_STATES.MOTION


func _atack_state():
	if _atk_condition != null:
		atk_disable_by_condition(_atk_condition)
		return
	if _combo_anim_list.size() == 0:
		if not animation.is_playing():
			master_state = MASTER_STATES.MOTION
		return
	
	if not _combo_await:
		origin.scale.x = input_direction if input_direction != 0 else origin.scale.x
		_combo_count = _combo_count +1 if _combo_current_atk == _combo_anim_list[0] else 0
		_combo_current_atk = _combo_anim_list[0]
		_anim_atk_combo()
		_combo_await = true
	elif not animation.is_playing():
		_combo_await = false


func reset_atk_props():
	_combo_anim_list.clear()
	atk_state = ATK_STATES.STATELESS
	_combo_current_atk = -1
	_combo_count = -1
	_combo_await = false


func atack_inputs(_atk, _is_onslaught := false):
	if (master_state == MASTER_STATES.DAMAGE 
			or motion_state == MOTION_STATES.IN_SLIDE
			or atk_state == ATK_STATES.CONDITIONAL
			or atk_state == ATK_STATES.ONSLAUGHT):
		return
	
	if motion_state == MOTION_STATES.IN_AIR and not _aereo_kick:
		return
	
	if _is_onslaught:
		atk_state = ATK_STATES.ONSLAUGHT
		
	if _combo_anim_list.size() == 0:
		master_state = MASTER_STATES.ATACK
		_combo_anim_list.append(_atk)


func atk_disable_by_condition(_condition := 0):
	match _condition:
		0: #se tocar o chao, ou inimigo
			if motion_state == MOTION_STATES.IN_AIR:
				if _hitbox_by_condition == null:
					_spawn_hitbox_condition(_hit_data_jump)
				animation.play(animation.current_animation)
			else:
				_disable_atk_condition()
		1: #se em slide
			if motion_state == MOTION_STATES.IN_SLIDE:
				if _hitbox_by_condition == null:
					_spawn_hitbox_condition(_hit_data_slide)
			else:
				_disable_atk_condition()


func _anim_atk_combo():
	if motion_state == MOTION_STATES.IN_AIR:
		_anim_atk_start(_aereo_kick)
		_atk_condition = 0
		return
	if _combo_current_atk < _atks.size():
		if _combo_count < _atks[_combo_current_atk].size() -1:
			_anim_atk_start(_atks[_combo_current_atk][_combo_count])
		
		elif _combo_count == _atks[_combo_current_atk].size() -1:
			_anim_atk_start(_atks[_combo_current_atk][_combo_count])
			_combo_count = -1


func _anim_atk_start(anim):
	animation.play(anim)
	_combo_anim_list.remove(0)


func _disable_atk_condition():
	_atk_condition = null
	if is_instance_valid(_hitbox_by_condition):
		_hitbox_by_condition.queue_free()
	_hitbox_by_condition = null


func _hited(_hit):
	if master_state == MASTER_STATES.DEAD:
		return
	master_state = MASTER_STATES.DAMAGE
	if animation.current_animation == "damage_2" or animation.current_animation == "damage_2_contact":
		return
	
	if _hit.size() == 3:
		if atk_state == ATK_STATES.IN_BLOQ:
			atk_state = ATK_STATES.STATELESS
			if _hit[2] == true:
				animation.play("damage_2")
				_take_damage(_hit)
				return
			animation.play("damage_1")
			_take_damage(_hit, true)
			return
		animation.play("damage_2")
		_take_damage(_hit)
		return
	
	if atk_state != ATK_STATES.IN_BLOQ:
		animation.play("damage_1")
		_take_damage(_hit)
		return
	animation.play("bloq")
	_knock_block( _hit, true )


func _knock_block(_hit, _is_blocking := false):
	origin.scale.x = sign(-_hit[1].x) if _hit[1].x != 0 else origin.scale.x
	if _is_blocking:
		motion += Vector2(-origin.scale.x * 50, 0)
		return
	motion += _hit[1]


func _take_damage(_hit, _is_blocking := false):
	_posture_recharge = 0.0
	if posture >= _hit[0]:
		posture -= _hit[0]
	else:
		life -= _hit[0] - posture
		posture = 0.0
	_knock_block( _hit, _is_blocking)


func spawn_hitbox(_data : Array, _pos : Vector2, _size : Vector2, _mask := 1):
	var _hit = hitbox.instance()
	_hit.hit = _data
	_hit.position = _pos
	_hit.extent = _size
	_hit.collide = _mask
	origin.add_child(_hit)


func _spawn_hitbox_condition(_data):
	var _hit = hitbox_free_by_condition.instance()
	_data[0][1] *= origin.scale
	_hit.hit = _data[0]
	_hit.position = _data[1]
	_hit.extent = _data[2]
	_hit.collide = _data[3]
	_hitbox_by_condition = _hit
	origin.add_child(_hit)


func _calc_posture(_delta):
	if master_state == MASTER_STATES.DEAD:
		return
	if _posture_recharge < POSTURE_TIME_RECHARGE:
		_posture_recharge += _delta
	else:
		_posture_recharge = POSTURE_TIME_RECHARGE
		if posture < POSTURE_MAX:
			posture += 25.0 * _delta
		else:
			posture = POSTURE_MAX


func _die():
	if master_state == MASTER_STATES.DEAD:
		return
	master_state = MASTER_STATES.DEAD
	Gameplay.end_game()
	animation.play("die")

