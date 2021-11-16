tool
extends Position2D


func _process(delta):
	update()


func _draw():
	draw_circle(Vector2.ZERO, 5, Color(0, 0, 0))

