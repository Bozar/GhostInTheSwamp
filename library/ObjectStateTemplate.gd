extends Node2D
class_name Game_ObjectStateTemplate


# <id: int>: <state: T>
var _id_to_state := {}


func create_object(_sprite_data: Game_BasicSpriteData) -> void:
	pass


func remove_object(id: int) -> void:
	var __ = _id_to_state.erase(id)
