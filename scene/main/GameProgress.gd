extends Node2D
class_name Game_GameProgress


const HARBOR_HELPER := "HarborHelper"

var _ref_SwitchSprite: Game_SwitchSprite
var _ref_ObjectState: Game_ObjectState
var _ref_RandomNumber: Game_RandomNumber
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_CreateObject: Game_CreateObject
var _ref_RemoveObject: Game_RemoveObject

var _ref_Schedule: Game_Schedule
var _ref_EndGame: Game_EndGame
var _ref_Palette: Game_Palette

var _ref_HarborHelper: Game_HarborHelper


func _ready() -> void:
	_ref_HarborHelper = get_node(HARBOR_HELPER)


func _on_Schedule_turn_starting(_current_sprite: Sprite) -> void:
	pass


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass


func _on_InitWorld_world_initialized() -> void:
	_set_child_reference()
	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var island: Sprite = _ref_DungeonBoard.get_sprites_by_tag(
			Game_SubTag.ISLAND)[0]
	var coord := Game_ConvertCoord.sprite_to_coord(island)

	for i in Game_CoordCalculator.get_neighbor(coord, 1):
		if _ref_DungeonBoard.has_building(i):
			_ref_HarborHelper.toggle_harbor(i, true)
			return


func _set_child_reference() -> void:
	for i in ["_ref_DungeonBoard", "_ref_SwitchSprite", "_ref_ObjectState"]:
		_ref_HarborHelper[i] = get(i)
