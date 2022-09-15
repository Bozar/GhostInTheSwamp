extends Node2D
class_name GameProgress


const CHILD_REFERENCE := {
	NodeTag.HARBOR_HELPER: [
		NodeTag.REF_DUNGEON_BOARD, NodeTag._MANAGE_STATE,
	],
}

var _ref_RandomNumber: RandomNumber
var _ref_DungeonBoard: DungeonBoard
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject

var _ref_Schedule: Schedule
var _ref_EndGame: EndGame
var _ref_Palette: Palette

var _manage_state: ManageObjectState


func _ready() -> void:
	_manage_state = $ManageObjectState


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass


func _on_InitWorld_world_initialized() -> void:
	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var island: Sprite = $FindObject.get_sprites_by_tag(SubTag.ISLAND)[0]
	var coord := ConvertCoord.sprite_to_coord(island)
	var harbor: Sprite

	for i in CoordCalculator.get_neighbor(coord, 1):
		if _ref_DungeonBoard.has_building(i):
			harbor = _ref_DungeonBoard.get_building(i)
			$HarborHelper.toggle_harbor(harbor, true)
			return
