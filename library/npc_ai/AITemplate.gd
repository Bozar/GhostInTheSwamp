# class_name AITemplate


# const INVALID_START_POINT: String = "Unreachable start point."

# var print_text: String setget set_print_text, get_print_text

# var _ref_ObjectState: ObjectState
# var _ref_DungeonBoard: DungeonBoard
# var _ref_SwitchSprite: SwitchSprite
# var _ref_EndGame: EndGame
# var _ref_RandomNumber: RandomNumber
# var _ref_RemoveObject: RemoveObject
# var _ref_CreateObject: CreateObject
# var _ref_Schedule: Schedule
# var _ref_Palette: Palette

# var _self: Sprite
# var _pc_pos: IntCoord
# var _self_pos: IntCoord
# var _dungeon: Dictionary


# # Refer: EnemyAI.gd.
# func _init(parent_node: Node2D) -> void:
# 	_ref_ObjectState = parent_node._ref_ObjectState
# 	_ref_DungeonBoard = parent_node._ref_DungeonBoard
# 	_ref_SwitchSprite = parent_node._ref_SwitchSprite
# 	_ref_EndGame = parent_node._ref_EndGame
# 	_ref_RandomNumber = parent_node._ref_RandomNumber
# 	_ref_RemoveObject = parent_node._ref_RemoveObject
# 	_ref_CreateObject = parent_node._ref_CreateObject
# 	_ref_Schedule = parent_node._ref_Schedule
# 	_ref_Palette = parent_node._ref_Palette


# # Override.
# func take_action() -> void:
# 	pass


# # Override.
# func remove_data(_actor: Sprite) -> void:
# 	pass


# func get_print_text() -> String:
# 	return print_text


# func set_print_text(_text: String) -> void:
# 	return


# func set_local_var(actor: Sprite) -> void:
# 	_self = actor
# 	_self_pos = ConvertCoord.sprite_to_coord(_self)
# 	_pc_pos = _ref_DungeonBoard.get_pc_coord()


# func _approach_pc(start_point := [_pc_pos], step_length: int = 1, step_count: int = 1,
# 		opt_passable_arg := []) -> void:
# 	var destination: Array

# 	DungeonSize.init_dungeon_grids_by_func(_dungeon, self,
# 			"_get_init_value", [], false)
# 	for i in start_point:
# 		if _dungeon[i.x][i.y] == PathFindingData.UNKNOWN:
# 			_dungeon[i.x][i.y] = PathFindingData.DESTINATION
# 		else:
# 			push_warning(INVALID_START_POINT)
# 			return
# 	_dungeon = DijkstraPathFinding.get_map(_dungeon, start_point)

# 	for i in range(0, step_count):
# 		if (i > 0) and _stop_move():
# 			break
# 		destination = DijkstraPathFinding.get_path(_dungeon,
# 				_self_pos.x, _self_pos.y, step_length,
# 				self, "_is_passable_func", opt_passable_arg)

# 		if destination.size() > 0:
# 			ArrayHelper.rand_picker(destination, 1, _ref_RandomNumber)
# 			_ref_DungeonBoard.move_actor_xy(_self_pos.x, _self_pos.y,
# 					destination[0].x, destination[0].y)
# 			_self_pos = destination[0]


# func _get_init_value(x: int, y: int, _opt_arg: Array) -> int:
# 	if _is_obstacle(x, y):
# 		return PathFindingData.OBSTACLE
# 	else:
# 		return PathFindingData.UNKNOWN


# func _is_obstacle(x: int, y: int) -> bool:
# 	return _ref_DungeonBoard.has_building_xy(x, y)


# func _is_passable_func(source_array: Array, current_index: int,
# 		_opt_arg: Array) -> bool:
# 	var x: int = source_array[current_index].x
# 	var y: int = source_array[current_index].y
# 	return not _ref_DungeonBoard.has_actor_xy(x, y)


# func _stop_move() -> bool:
# 	return false
