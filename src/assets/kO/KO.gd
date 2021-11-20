extends Control

onready var _tween = $Tween
onready var _label = $ko_text
onready var _splash_top = $splash_1
onready var _splash_down = $splash_2
onready var _flash = $flash


func _init():
	Gameplay.hud_ko_ref = self


func start():
	Engine.time_scale = 0.2
	yield(get_tree().create_timer(0.3), "timeout")
	Engine.time_scale = 1
	
	_flash.visible = true
	_label.visible = true
	_tween.interpolate_property(_flash, "color", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_EXPO)
	_tween.interpolate_property(_label, "self_modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
	_tween.start()
	yield(_tween, "tween_completed")
	
	_splash_top.visible = true
	_splash_down.visible = true
	_tween.interpolate_property(_splash_top, "rect_rotation", -10, 0, 0.2)
	_tween.interpolate_property(_splash_down, "rect_rotation", -10, 0, 0.2)
	_tween.interpolate_property(_splash_top, "rect_position", Vector2(-1460, -305), Vector2(-407, -305), 0.2, Tween.TRANS_CIRC)
	_tween.interpolate_property(_splash_down, "rect_position", Vector2(640, 0), Vector2(-407, 0), 0.2, Tween.TRANS_CIRC)
	_tween.start()





