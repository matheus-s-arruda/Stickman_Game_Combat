extends Node


var hud_center_ref
var world_ref
var player_1
var player_2

var spawn_point_1 = Vector2(-300, 680)
var spawn_point_2 = Vector2(-1400, 680)





func end_game():
	hud_center_ref.shot_ko_scene()
