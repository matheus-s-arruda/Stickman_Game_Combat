tool
extends Position2D

export(float) var max_length = 100.0

const COLOR_RED = Color(1, 0, 0)
const COLOR_BLACK = Color(0, 0, 0)

var _color = COLOR_BLACK

func _process(delta):
	
	if global_position.distance_to(get_parent().global_position) > max_length:
		_color = COLOR_RED
	else:
		_color = COLOR_BLACK
	
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, _color)
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), _color, 10)

