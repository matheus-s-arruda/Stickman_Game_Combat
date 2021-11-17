extends Node

const FX_HIT_PARTICLE = preload("res://src/assets/hits/hit_particles.tscn")
const FX_HIT_CIRCE = preload("res://src/assets/hits/impact_circle.tscn")

var hud_ko_ref
var world_ref
var player_1
var player_2

var spawn_point_1 = Vector2(-300, 680)
var spawn_point_2 = Vector2(-1400, 680)





func end_game():
	hud_ko_ref.start()
