class_name CoordCalculator


const RAY_DIRECTION := "Invalid ray direction: [%s, %s] -> [%s, %s]."


static func get_range_xy(source_x: int, source_y: int,
		target_x: int, target_y: int) -> int:
	var delta_x: int = abs(source_x - target_x) as int
	var delta_y: int = abs(source_y - target_y) as int

	return delta_x + delta_y


static func get_range(source: IntCoord, target: IntCoord) -> int:
	return get_range_xy(source.x, source.y, target.x, target.y)


static func is_in_range_xy(source_x: int, source_y: int,
		target_x: int, target_y: int, max_range: int) -> bool:
	return get_range_xy(source_x, source_y, target_x, target_y) <= max_range


static func is_in_range(source: IntCoord, target: IntCoord, max_range: int) \
		-> bool:
	return is_in_range_xy(source.x, source.y, target.x, target.y, max_range)


static func is_out_of_range_xy(source_x: int, source_y: int,
		target_x: int, target_y: int, max_range: int) -> bool:
	return not is_in_range_xy(source_x, source_y, target_x, target_y,
			max_range)


static func is_out_of_range(source: IntCoord, target: IntCoord,
		max_range: int) -> bool:
	return is_out_of_range_xy(source.x, source.y, target.x, target.y,
			max_range)


static func get_neighbor_xy(x: int, y: int, max_range: int,
		has_center := false) -> Array:
	var neighbor := []

	for i in range(x - max_range, x + max_range + 1):
		for j in range(y - max_range, y + max_range + 1):
			if (i == x) and (j == y):
				continue
			if is_inside_dungeon(i, j) \
					and is_in_range_xy(x, y, i, j, max_range):
				neighbor.push_back(IntCoord.new(i, j))
	if has_center:
		neighbor.push_back(IntCoord.new(x, y))
	return neighbor


static func get_neighbor(center: IntCoord, max_range: int,
		has_center := false) -> Array:
	return get_neighbor_xy(center.x, center.y, max_range, has_center)


static func get_block(x_top_left: int, y_top_left: int, width: int,
		height: int) -> Array:
	var coord := []

	for i in range(x_top_left, x_top_left + width):
		for j in range(y_top_left, y_top_left + height):
			if is_inside_dungeon(i, j):
				coord.push_back(IntCoord.new(i, j))
	return coord


static func get_mirror_image_xy(source_x: int, source_y: int,
		center_x: int, center_y: int) -> IntCoord:
	var x: int = center_x * 2 - source_x
	var y: int = center_y * 2 - source_y

	return IntCoord.new(x, y)


static func get_mirror_image(source: IntCoord, center: IntCoord) -> IntCoord:
	return get_mirror_image_xy(source.x, source.y, center.x, center.y)


static func is_inside_dungeon(x: int, y: int) -> bool:
	return (x >= 0) and (x < DungeonSize.MAX_X) \
			and (y >= 0) and (y < DungeonSize.MAX_Y)


static func get_ray_direction(source_coord: IntCoord, target_coord: IntCoord) \
		-> int:
	if source_coord.x == target_coord.x:
		if source_coord.y < target_coord.y:
			return DirectionTag.UP
		elif source_coord.y > target_coord.y:
			return DirectionTag.DOWN
	elif source_coord.y == target_coord.y:
		if source_coord.x > target_coord.x:
			return DirectionTag.LEFT
		elif source_coord.x < target_coord.x:
			return DirectionTag.RIGHT
	push_warning(RAY_DIRECTION % [source_coord.x, source_coord.y,
			target_coord.x, target_coord.y])
	return DirectionTag.INVALID_DIRECTION


# ray_direction: DirectionTag.[UP|DOWN|LEFT|RIGHT]
# is_obstacle_func(x: int, y: int, opt_arg: Array) -> bool
# Return an array of coordinates: [IntCoord, ...].
static func get_ray_path(source_coord: IntCoord, max_range: int,
		ray_direction: int, has_start_point: bool, has_end_point: bool,
		func_host: Object, is_obstacle_func: String, opt_arg := []) -> Array:
	var x := source_coord.x
	var y := source_coord.y
	var is_obstacle := funcref(func_host, is_obstacle_func)
	var shift := DirectionTag.get_coord_by_direction(source_coord, ray_direction)
	var ray_path := []

	if has_start_point:
		ray_path.push_back(source_coord)
	for _i in range(0, max_range):
		x += shift.x
		y += shift.y
		if not is_inside_dungeon(x, y):
			return ray_path
		if is_obstacle.call_func(x, y, opt_arg):
			if has_end_point:
				ray_path.push_back(IntCoord.new(x, y))
			return ray_path
		ray_path.push_back(IntCoord.new(x, y))
	return ray_path


static func is_in_square(coord: IntCoord, center: IntCoord, half_size: int) \
		-> bool:
	for i in ["x", "y"]:
		if abs(coord[i] - center[i]) > half_size:
			return false
	return true


static func is_same_coord(this_coord: IntCoord, that_coord: IntCoord) -> bool:
	return (this_coord.x == that_coord.x) and (this_coord.y == that_coord.y)
