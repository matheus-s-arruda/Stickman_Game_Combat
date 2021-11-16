tool
extends Position2D



func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 13, Color(0, 0, 0))
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), Color(0, 0, 0), 10)
