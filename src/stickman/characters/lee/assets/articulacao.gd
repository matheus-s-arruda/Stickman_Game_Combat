tool
extends Position2D

var color := Color(0.36, 0.15, 0.15)


func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, color)

