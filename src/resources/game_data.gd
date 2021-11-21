class_name GameData
extends Resource


enum stick_name {LEE}


const sceneries_list = [
	"res://src/world/arena/desert.tscn",
]

const characters_list = {
	stick_name.LEE : [
			preload("res://src/stickman/characters/lee/lee.tscn"),
			preload("res://img/stickmans/lee/lee.png"),
			"Lee", Color(0.4, 0.15, 0.15), Color(0.25, 0.07, 0.07), Color(0.5, 0.25, 0.25),
			],
}





func get_character(_id : int, _data := 0):
	return characters_list[ _id ][_data]





