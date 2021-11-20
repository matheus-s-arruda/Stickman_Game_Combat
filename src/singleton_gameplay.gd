extends Node

const camera = preload("res://src/world/Camera.tscn")
const gamedata = preload("res://src/resources/game_data.tres")
const FX_HIT_PARTICLE = preload("res://src/assets/hits/hit_particles.tscn")
const FX_HIT_CIRCE = preload("res://src/assets/hits/impact_circle.tscn")
const CUTSCENE_TIME = 4.0

"refenrecias"
var hud_ko_ref
var player_1
var player_2
" ... "

var player_1_id
var player_2_id
var scenery_id

func end_game():
	hud_ko_ref.start()
	if player_2.master_state != player_2.MASTER_STATES.DEAD:
		player_2.master_state = player_2.MASTER_STATES.CUTSCENE
		player_2.animation.play("idle")


func start_game():
	player_1 = gamedata.get_character(player_1_id).instance()
	player_2 = gamedata.get_character(player_2_id).instance()
	get_tree().change_scene( gamedata.sceneries_list[scenery_id] )
	
	yield(get_tree().create_timer(CUTSCENE_TIME), "timeout") # tempo cutscene
	player_1.master_state = player_1.MASTER_STATES.MOTION
	player_2.master_state = player_2.MASTER_STATES.MOTION




