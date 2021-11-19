tool
extends Position2D

export(Color) var color := Color(0.6, 0.45, 0.55)

func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 13, color)
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), color, 10)
