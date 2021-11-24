tool
extends Position2D


var color := Color(0.4, 0.4, 0.3)

func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 3, color)
	draw_circle(to_local(get_parent().global_position), 3, color)
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), color, 6)
