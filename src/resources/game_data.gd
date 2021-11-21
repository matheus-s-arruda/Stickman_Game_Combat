class_name GameData
extends Resource


enum stick_name {LEE}
enum stick_info {NAME, IMG, SCENE, AUTOPLAY, COLORS}

const sceneries_list = [
	"res://src/world/arena/desert.tscn",
]


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



