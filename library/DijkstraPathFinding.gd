class_name DijkstraPathFinding


# Find the next step.
# Call func_host.is_passable_func() to verify if a grid can be entered.
# is_passable_func(source_array: Array, current_index: int,
#> opt_arg: Array) -> bool
static func get_path(dungeon: Dictionary, start_coord: IntCoord,
		step_length: int, func_host: Object, is_passable_func: String,
		opt_arg := []) -> Array:
	var neighbor := CoordCalculator.get_neighbor(start_coord, step_length)
	var min_distance := PathFindingData.OBSTACLE
	var x: int
	var y: int
	var current_index := 0

	ArrayHelper.filter_element(neighbor, func_host, is_passable_func, opt_arg)

	for i in neighbor.size():
		x = neighbor[i].x
		y = neighbor[i].y
		if _is_valid_distance(dungeon, x, y, PathFindingData.OBSTACLE):
			if dungeon[x][y] < min_distance:
				min_distance = dungeon[x][y]
				ArrayHelper.swap_element(neighbor, 0, i)
				current_index = 1
			elif dungeon[x][y] == min_distance:
				ArrayHelper.swap_element(neighbor, current_index, i)
				current_index += 1

	neighbor.resize(current_index)
	return neighbor


# Create a distance map.
static func get_map(dungeon: Dictionary, end_point: Array) -> Dictionary:
	if end_point.size() < 1:
		return dungeon

	var check: IntCoord = end_point.pop_front()
	var neighbor := CoordCalculator.get_neighbor(check, 1)

	for i in neighbor:
		if dungeon[i.x][i.y] == PathFindingData.UNKNOWN:
			dungeon[i.x][i.y] = _get_distance(dungeon, i)
			end_point.push_back(i)
	return get_map(dungeon, end_point)


static func _get_distance(dungeon: Dictionary, center_coord: IntCoord) -> int:
	var neighbor := CoordCalculator.get_neighbor(center_coord, 1)
	var min_distance: int = PathFindingData.OBSTACLE
	var x: int
	var y: int

	for i in neighbor:
		x = i.x
		y = i.y
		if _is_valid_distance(dungeon, x, y, min_distance):
			min_distance = dungeon[x][y]
	min_distance = min(min_distance + 1, PathFindingData.OBSTACLE) as int
	return min_distance


static func _is_valid_distance(dungeon: Dictionary, x: int, y: int,
		max_distance: int) -> bool:
	return (dungeon[x][y] < max_distance) \
			and (dungeon[x][y] > PathFindingData.UNKNOWN)
