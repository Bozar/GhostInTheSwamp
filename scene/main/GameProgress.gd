extends Node2D
class_name Game_GameProgress


const CHILD_REFERENCE := {
	Game_NodeTag.HARBOR_HELPER: [
		Game_NodeTag.REF_DUNGEON_BOARD, Game_NodeTag._MANAGE_STATE,
	],
}

var _ref_RandomNumber: Game_RandomNumber
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_CreateObject: Game_CreateObject
var _ref_RemoveObject: Game_RemoveObject

var _ref_Schedule: Game_Schedule
var _ref_EndGame: Game_EndGame
var _ref_Palette: Game_Palette

var _manage_state: Game_ManageObjectState


func _ready() -> void:
	_manage_state = $ManageObjectState


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass


func _on_InitWorld_world_initialized() -> void:
	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var island: Sprite = $FindObject.get_sprites_by_tag(Game_SubTag.ISLAND)[0]
	var coord := Game_ConvertCoord.sprite_to_coord(island)
	var harbor: Sprite

	for i in Game_CoordCalculator.get_neighbor(coord, 1):
		if _ref_DungeonBoard.has_building(i):
			harbor = _ref_DungeonBoard.get_building(i)
			$HarborHelper.toggle_harbor(harbor, true)
			return
