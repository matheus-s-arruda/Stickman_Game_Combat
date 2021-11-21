tool
extends Position2D

var color := Color(0.6, 0.45, 0.55)

func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, color)

