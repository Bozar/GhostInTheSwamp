class_name ActorWalkPath


const INVALID_START_POINT: String = "Unreachable start point."


# Return [coord_1: IntCoord, ...]. Use ActorWalkPath as func_host by default.
static func get_path(end_point: IntCoord, actor_coord: IntCoord,
		dungeon: Dictionary, ref_random: RandomNumber, func_host: Object,
		init_value_func := "_get_init_value", passable_func := "_is_passable") \
		-> Array:
	var start_point := actor_coord
	var next_coords: Array
	var walk_path := []

	DungeonSize.init_dungeon_grids_by_func(dungeon, func_host, init_value_func,
			[], false)
	if dungeon[end_point.x][end_point.y] == PathFindingData.UNKNOWN:
		dungeon[end_point.x][end_point.y] = PathFindingData.DESTINATION
	else:
		push_warning(INVALID_START_POINT)
		return walk_path
	dungeon = DijkstraPathFinding.get_map(dungeon, [end_point])

	while not CoordCalculator.is_same_coord(start_point, end_point):
		next_coords = DijkstraPathFinding.get_path(dungeon, start_point, 1,
				func_host, passable_func)
		start_point = ArrayHelper.get_rand_element(next_coords, ref_random)
		# End_point will be pused into walk_path in the last loop.
		walk_path.push_back(start_point)
	walk_path.invert()
	return walk_path


static func _get_init_value(x: int, y: int, _opt_arg: Array) -> int:
	var coord := IntCoord.new(x, y)

	if FindObjectHelper.has_swamp(coord) or FindObject.has_building(coord):
		return PathFindingData.OBSTACLE
	else:
		return PathFindingData.UNKNOWN


static func _is_passable(_source: Array, _index: int, _opt: Array) -> bool:
	return true
