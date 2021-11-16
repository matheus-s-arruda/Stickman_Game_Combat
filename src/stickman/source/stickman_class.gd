class_name Stickman
extends KinematicBody2D

const hitbox = preload("res://src/stickman/physics/hitbox.tscn")
const hitbox_free_by_condition = preload("res://src/stickman/physics/hitbox_free_by_condition.tscn")

const SPEED = 800
const GRAVITY = 1176
const JUMP_FORCE = 600

export(NodePath) onready var origin = get_node(origin)
export(NodePath) onready var animation = get_node(animation)
export(Array, Array, String) var _atks
export(String) var _aereo_kick : String
export(Array, String) var _atk_special

var life := 100
var posture := 25
var motion : Vector2
var hit := [] setget _hited

var input_direction := 0
var input_jump := 0
var input_down := false
var input_bloq := true

var _in_air = false
var _in_damage = false
var _in_atack = false
var _in_onslaught = false
var _in_slide = false
var _in_down = false
var _in_bloq = false
var _flag_swap_dir := 0

var _bloq_break_down = false
var _atk_condition = null
var _combo_anim_list = []
var _combo_await := false
var _combo_count := -1
var _combo_current_atk = -1

var _damage_nockback = false

var _hitbox_by_condition = null
var _hit_data_jump := []
var _hit_data_slide := []


func _physics_process(delta):
	var speed_target := 0.0
	var speed_target_air := motion.x
	
	_damaged_state()
	_motion_state()
	_atack_state()
	
	motion = move_and_slide(motion, Vector2.UP, true)
	
	if is_on_floor():
		_in_air = false
		motion.y = 0
	else:
		motion.y += GRAVITY * delta
		if abs(motion.y) > 20:
			_in_air = true
			if _in_damage:
				_damage_nockback = true
	
	if _in_damage:
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.1)
		return
	
	if input_down:
		if abs(motion.x) > 200:
			if not _in_down:
				_in_slide = true
		else:
			_in_slide = false
			_in_down = true
	else:
		_in_down = false
		_in_slide = false
	
	if _in_slide:
		motion.x = lerp(motion.x, 0, 0.007)
		return
	elif _in_down:
		motion.x = lerp(motion.x, input_direction * SPEED, 0.07)
	
	if _in_atack:
		_in_bloq = false
		if not _in_air:
			motion.x = lerp(motion.x, 0, 0.15)
		return
	
	_in_bloq = _in_down or input_bloq
	
	if is_on_floor():
		motion.y = input_jump * -JUMP_FORCE
		speed_target = 0
		
		if animation.current_animation == "run":
			speed_target = input_direction * SPEED
		
		if animation.current_animation == "walk":
			speed_target = input_direction * SPEED * 0.18
		
		motion.x = lerp(motion.x, speed_target, 0.2)
	else:
		speed_target_air = clamp(speed_target_air -(-input_direction * 100), -SPEED, SPEED)
		motion.x = lerp(motion.x, speed_target_air, 0.2)


func atack_inputs(_atk, _is_special := false):
	if _in_damage or _in_slide or _atk_condition != null:
		return
	
	if _in_air and not _aereo_kick:
		return
	
	if _combo_anim_list.size() == 0:
		_in_onslaught = _is_special
		_in_atack = true
		_combo_anim_list.append(_atk)


func atk_disable_by_condition(_condition := 0):
	match _condition:
		0: #se tocar o chao, ou inimigo
			if _in_air:
				if _hitbox_by_condition == null:
					_spawn_hitbox_condition(_hit_data_jump)
				animation.play(animation.current_animation)
			else:
				_disable_atk_condition()
			
		1: #se em slide
			if _in_slide:
				if _hitbox_by_condition == null:
					_spawn_hitbox_condition(_hit_data_slide)
			else:
				_disable_atk_condition()


func _motion_state():
	if _in_atack or _in_damage:
		return
	
	if _in_air:
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
		
		if _in_down:
			if input_direction == 0:
				animation.play("down_idle")
			else:
				animation.play("down_walk")
			return
		
		if _in_slide:
			if animation.current_animation != "slide":
				if animation.current_animation != "slide_in":
					animation.play("slide_in")
					return
			
			animation.play("slide")
			return
		
		elif animation.current_animation == "slide" or animation.current_animation == "slide_in":
			animation.play("slide_out")
			return
		
		if _flag_swap_dir != input_direction:
			if _flag_swap_dir == 0:
				if _in_bloq:
					animation.play("walk")
					return
				animation.play("run")
				_flag_swap_dir = input_direction
				return
				
			if input_direction == 0 and animation.current_animation == "run" and abs(motion.x) > 600:
				animation.play("run_stop")
				_flag_swap_dir = input_direction
				return
			
			_flag_swap_dir = input_direction
		
		elif input_direction != 0:
			if _in_bloq:
				animation.play("walk")
				return
			animation.play("run")
			return
		
		animation.play("idle")


func _damaged_state():
	if not _in_damage:
		_damage_nockback = false
		return
	
	_in_atack = false
	
	if _damage_nockback and is_on_floor() and animation.current_animation == "damage_2":
		animation.play("damage_2_contact")
	
	
	if (animation.current_animation_length - animation.current_animation_position) > 0.05:
		return
	
	_in_damage = false


func _atack_state():
	if _in_slide:
		_atk_condition = 1
		_in_atack = true
	
	if _in_atack:
		if _atk_condition != null:
			atk_disable_by_condition(_atk_condition)
			return
		
		if _combo_anim_list.size() == 0:
			if _in_onslaught:
				if not animation.is_playing():
					pass
				return
			
			if not animation.is_playing():
				_in_atack = false
			return
		
		if not _combo_await:
			if _combo_current_atk == _combo_anim_list[0]:
				_combo_count += 1
			else:
				_combo_count = 0
			
			_combo_current_atk = _combo_anim_list[0]
			_anim_atk_combo()
			_combo_await = true
			
		elif not animation.is_playing():
			_combo_await = false
	
	else:
		_combo_current_atk = -1
		_combo_count = -1
		_combo_await = false


func _anim_atk_combo():
	if _in_air:
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
	_in_damage = true
	
	if animation.current_animation == "damage_2" or animation.current_animation == "damage_2_contact":
		return
	
	if _hit.size() == 3:
		if _in_bloq:
			_in_bloq = false
			if _hit[2] == true:
				animation.play("damage_2")
				_take_damage(_hit)
				return
			
			animation.play("damage_1")
			life -= _hit[0] * 0.5
			_knock_block( sign(-_hit[1].x) )
			return
		
		animation.play("damage_2")
		_take_damage(_hit)
		return
	
	if not _in_bloq:
		animation.play("damage_1")
		_take_damage(_hit)
		return
	
	animation.play("bloq")
	_knock_block( sign(-_hit[1].x) )


func _knock_block(_knock):
	origin.scale.x = _knock if _knock != 0 else origin.scale.x
	motion += Vector2(-origin.scale.x * 50, 0)


func _take_damage(_hit):
	life -= _hit[0]
	origin.scale.x = sign(-_hit[1].x) if _hit[1].x != 0 else origin.scale.x
	motion += _hit[1]


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



