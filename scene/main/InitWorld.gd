extends Node2D
class_name Game_InitWorld


const CHILD_REFERENCE := {
	Game_NodeTag.INIT_WORLD_HELPER: [
		Game_NodeTag.REF_RANDOM_NUMBER, Game_NodeTag.REF_CREATE_OBJECT,
		Game_NodeTag.REF_DUNGEON_BOARD,
	],
}
const SIG_WORLD_INITIALIZED := "world_initialized"

signal world_selected(new_world)
signal world_initialized()

var _ref_RandomNumber: Game_RandomNumber
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_CreateObject: Game_CreateObject
var _ref_GameSetting: Game_GameSetting


func init_world() -> void:
	var pc_coord: Game_IntCoord

	_ref_GameSetting.load_setting()
	emit_signal("world_selected", "demo")

	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	$InitWorldHelper.init_ground_building()
	pc_coord = _init_pc()
	_init_indicator(pc_coord.x, pc_coord.y)

	emit_signal(SIG_WORLD_INITIALIZED)


func _init_pc() -> Game_IntCoord:
	var grounds := _ref_DungeonBoard.get_sprites_by_tag(Game_SubTag.LAND)
	var ground_coord: Game_IntCoord

	Game_ArrayHelper.shuffle(grounds, _ref_RandomNumber)
	ground_coord = Game_ConvertCoord.sprite_to_coord(grounds[0])
	_ref_CreateObject.create_actor(Game_SubTag.PC, ground_coord)

	return ground_coord


func _init_indicator(x: int, y: int) -> void:
	_ref_CreateObject.create_xy(Game_MainTag.INDICATOR, Game_SubTag.ARROW_RIGHT,
			0, y, 0,
			-Game_DungeonSize.ARROW_MARGIN, 0)

	_ref_CreateObject.create_xy(Game_MainTag.INDICATOR, Game_SubTag.ARROW_DOWN,
			x, 0, 0,
			0, -Game_DungeonSize.ARROW_MARGIN)

	_ref_CreateObject.create_xy(Game_MainTag.INDICATOR, Game_SubTag.ARROW_UP,
			x, Game_DungeonSize.MAX_Y - 1, 0,
			0, Game_DungeonSize.ARROW_MARGIN)
