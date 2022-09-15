extends Node2D
class_name InitWorld


const CHILD_REFERENCE := {
	NodeTag.INIT_WORLD_HELPER: [
		NodeTag.REF_RANDOM_NUMBER, NodeTag.REF_CREATE_OBJECT,
		NodeTag.REF_DUNGEON_BOARD,
	],
}

signal world_selected(new_world)
signal world_initialized()

var _ref_RandomNumber: RandomNumber
var _ref_DungeonBoard: DungeonBoard
var _ref_CreateObject: CreateObject
var _ref_GameSetting: GameSetting


func init_world() -> void:
	var pc_coord: IntCoord

	_ref_GameSetting.load_setting()
	emit_signal("world_selected", "demo")

	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	$InitWorldHelper.init_ground_building()
	pc_coord = _init_pc()
	_init_indicator(pc_coord.x, pc_coord.y)

	emit_signal(SignalTag.WORLD_INITIALIZED)


func _init_pc() -> IntCoord:
	var grounds: Array = $FindObject.get_sprites_by_tag(SubTag.LAND)
	var ground_coord: IntCoord

	ArrayHelper.shuffle(grounds, _ref_RandomNumber)
	ground_coord = ConvertCoord.sprite_to_coord(grounds[0])
	_ref_CreateObject.create_actor(SubTag.PC, ground_coord)

	return ground_coord


func _init_indicator(x: int, y: int) -> void:
	var tag_to_data := {
		SubTag.ARROW_RIGHT: [
			0, y, -DungeonSize.ARROW_MARGIN, 0
		],
		SubTag.ARROW_DOWN: [
			x, 0, 0, -DungeonSize.ARROW_MARGIN
		],
		SubTag.ARROW_UP: [
			x, DungeonSize.MAX_Y - 1, 0, DungeonSize.ARROW_MARGIN
		],
	}

	for i in tag_to_data.keys():
		_ref_CreateObject.create_xy(MainTag.INDICATOR, i,
				tag_to_data[i][0], tag_to_data[i][1],
				tag_to_data[i][2], tag_to_data[i][3])
