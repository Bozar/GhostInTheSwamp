extends Node2D
class_name Game_InitWorldHelper


var _ref_RandomNumber: Game_RandomNumber
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_CreateObject: Game_CreateObject


func init_ground_building() -> void:
	_set_reference()
	_ref_CreateObject.create_ground_xy(Game_SubTag.LAND, 5, 5)


func _set_reference() -> void:
	_ref_RandomNumber = get_parent()._ref_RandomNumber
	_ref_DungeonBoard = get_parent()._ref_DungeonBoard
	_ref_CreateObject = get_parent()._ref_CreateObject
