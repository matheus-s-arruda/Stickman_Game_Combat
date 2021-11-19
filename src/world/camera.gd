extends Camera2D


var _zoom_fator := 1.0

func _ready():
	set_process(false)


func _process(delta):
	var a = Gameplay.player_1.to_local(Gameplay.player_2.global_position)
	var d = Gameplay.player_1.global_position.distance_to(Gameplay.player_2.global_position)
	_zoom_fator = lerp(_zoom_fator, clamp(d * 0.002, 0.8, 1.15), 0.16)
	
	position = a * 0.5
	position.y -= 200
	zoom = Vector2.ONE * _zoom_fator


func set_parent():
	get_parent().remove_child(self)
	Gameplay.player_1.add_child(self)
	set_process(true)
