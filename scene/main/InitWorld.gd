extends Node2D
class_name InitWorld


signal world_selected(new_world)
signal world_initialized()

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_Setting: Setting
var _ref_Schedule: Schedule


func init_world() -> void:
	var pc_coord: IntCoord

	_ref_Setting.load_setting()
	emit_signal("world_selected", "demo")

	$InitWorldHelper.set_reference()
	$InitWorldHelper.init_ground_building()
	pc_coord = _init_pc()
	_init_indicator(pc_coord.x, pc_coord.y)

	emit_signal(SignalTag.WORLD_INITIALIZED)
	_ref_Schedule.start_first_turn()


func _init_pc() -> IntCoord:
	var grounds := FindObject.get_sprites_with_tag(SubTag.LAND)
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
	var arrow_data: Array
	var coord: IntCoord
	var x_offset: int
	var y_offset: int

	for i in tag_to_data.keys():
		arrow_data = tag_to_data[i]
		coord = IntCoord.new(arrow_data[0], arrow_data[1])
		x_offset = arrow_data[2]
		y_offset = arrow_data[3]
		_ref_CreateObject.create(MainTag.INDICATOR, i, coord, [], x_offset,
				y_offset)
