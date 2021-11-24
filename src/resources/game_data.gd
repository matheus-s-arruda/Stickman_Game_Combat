class_name GameData
extends Resource


enum scenery_name {DESERT, MONTAINS}
enum scenery_info {SCENE, CAMERA_LIMITS}
enum stick_info {NAME, IMG, SCENE, AUTOPLAY, COLOR}
enum stick_name {LEE, MASTER_HONG}


const sceneries_list = {
	scenery_name.DESERT : {
		scenery_info.SCENE : "res://src/world/arena/desert.tscn",
		scenery_info.CAMERA_LIMITS : Vector2(2000, 900) },
		
	scenery_name.MONTAINS : {
		scenery_info.SCENE : "res://src/world/arena/montains.tscn",
		scenery_info.CAMERA_LIMITS : Vector2(2000, 900) },
}

const characters_info = {
	stick_name.LEE : {
		stick_info.NAME : "Lee",
		stick_info.IMG : preload("res://img/stickmans/lee/lee.png"),
		stick_info.SCENE : preload("res://src/stickman/characters/lee/lee.tscn"),
		stick_info.AUTOPLAY : preload("res://src/stickman/characters/lee/Lee_autoplay.tscn"),
		stick_info.COLOR : Color(0.4, 0.15, 0.15),
	},
	stick_name.MASTER_HONG : {
		stick_info.NAME : "Master Hong",
		stick_info.IMG : preload("res://img/stickmans/lee/lee.png"),
		stick_info.SCENE : preload("res://src/stickman/characters/master_hong/master_hong.tscn"),
		#stick_info.AUTOPLAY : preload("res://src/stickman/characters/lee/Lee_autoplay.tscn"),
		stick_info.COLOR : Color(0.6, 0.48, 0),
	}
}


func get_stick_data(_id, _data):
	return characters_info[_id ][_data ]



