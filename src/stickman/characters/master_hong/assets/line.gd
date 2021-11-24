tool
extends Position2D

export(int) var _legth := 50

var color := Color(0.6, 0.48, 0)

func _process(delta):
	if position.length() > _legth:
		color = Color.red
	else:
		color = Color(0.6, 0.48, 0)
		
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, color)
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), color, 10)

