class_name GameData
extends Resource



var teste = preload("res://src/stickman/characters/lee/lee.tscn").instance()


const sceneries_list = [
	"res://src/world/arena/desert.tscn"
]


const characters_list = [
	[preload("res://src/stickman/characters/lee/lee.tscn")],
	
]





func get_character(_id : int):
	return characters_list[ _id ][0]





