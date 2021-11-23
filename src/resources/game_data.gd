class_name GameData
extends Resource


enum scenery_data {DESERT, MONTAINS}
enum scenery_info {SCENE, CAMERA_LIMITS}
enum stick_name {LEE}
enum stick_info {NAME, IMG, SCENE, AUTOPLAY, COLORS}


const sceneries_list = {
	scenery_data.DESERT : {
		scenery_info.SCENE : "res://src/world/arena/desert.tscn",
		scenery_info.CAMERA_LIMITS : Vector2(2000, 900) },
		
	scenery_data.MONTAINS : {
		scenery_info.SCENE : "res://src/world/arena/montains.tscn",
		scenery_info.CAMERA_LIMITS : Vector2(2000, 900) },
}

const characters_info = {
	stick_name.LEE : {
		stick_info.NAME : "Lee",
		stick_info.IMG : preload("res://img/stickmans/lee/lee.png"),
		stick_info.SCENE : preload("res://src/stickman/characters/lee/lee.tscn"),
		stick_info.AUTOPLAY : preload("res://src/stickman/characters/lee/Lee_autoplay.tscn"),
		stick_info.COLORS : [Color(0.4, 0.15, 0.15), Color(0.25, 0.07, 0.07), Color(0.5, 0.25, 0.25)]
	}
}


func get_stick_data(_id, _data):
	return characters_info[_id ][_data ]



