extends Position2D



func _on_hurtbox_area_entered(area):
	if get_parent()._in_atack or get_parent()._in_slide:
		area.hit = [1, scale.x]
