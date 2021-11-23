extends Node

const camera = preload("res://src/world/Camera.tscn")
const ray_shadow = preload("res://src/world/ray_shadow.tscn")
const gamedata = preload("res://src/resources/game_data.tres")
const FX_HIT_PARTICLE = preload("res://src/assets/hits/hit_particles.tscn")
const FX_SONIC_IMPACT = preload("res://src/assets/hits/sonic_impact.tscn")
const FX_IMPACT_JUMP = preload("res://src/assets/hits/impact_jump.tscn")
const FX_HIT_CIRCE = preload("res://src/assets/hits/impact_circle.tscn")
const CUTSCENE_TIME = 4.0

"refenrecias"
var hud_ko_ref : Node
var player_1 : Node
var player_2 : Node
"interface novo jogo"
var player_1_color : int
var player_2_color : int
var player_1_id : int
var player_2_id : int
var scenery_id : int
" ... "


func start_game():
	player_1 = gamedata.get_stick_data(player_1_id, gamedata.stick_info.SCENE).instance()
	player_2 = gamedata.get_stick_data(player_2_id, gamedata.stick_info.SCENE).instance()
	
	get_tree().change_scene( gamedata.sceneries_list[scenery_id ][gamedata.scenery_info.SCENE ] )
	
	yield(get_tree().create_timer(CUTSCENE_TIME), "timeout")
	player_1.master_state = player_1.MASTER_STATES.MOTION
	player_2.master_state = player_2.MASTER_STATES.MOTION


func end_game():
	hud_ko_ref.start()
	if player_2.master_state != player_2.MASTER_STATES.DEAD:
		player_2.master_state = player_2.MASTER_STATES.CUTSCENE
		player_2.animation.play("idle")
		
		yield(get_tree().create_timer(1),"timeout")
		player_2.animation.play("open")




