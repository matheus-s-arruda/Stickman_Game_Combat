tool
extends Position2D

#export(Color) var colaor := Color(0.6, 0.45, 0.55)
export(int) var _legth := 50

var color := Color(0.36, 0.15, 0.15)

func _process(delta):
	#color = Color(0.36, 0.15, 0.15) if position.length() < _legth else Color.aqua
	
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, color)
	draw_line(Vector2.ZERO, to_local(get_parent().global_position), color, 10)

