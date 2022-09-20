class_name CoordCalculator


const RAY_DIRECTION := "Invalid ray direction: [%s, %s] -> [%s, %s]."


static func get_range(source: IntCoord, target: IntCoord) -> int:
	var delta_x := abs(source.x - target.x) as int
	var delta_y := abs(source.y - target.y) as int
	return delta_x + delta_y


static func is_in_range(source: IntCoord, target: IntCoord, max_range: int) \
		-> bool:
	return get_range(source, target) <= max_range


static func is_out_of_range(source: IntCoord, target: IntCoord, max_range: int) \
		-> bool:
	return not is_in_range(source, target, max_range)


static func get_neighbor(center: IntCoord, max_range: int, has_center := false) \
		-> Array:
	var neighbor := []
	var new_coord: IntCoord

	for i in range(center.x - max_range, center.x + max_range + 1):
		for j in range(center.y - max_range, center.y + max_range + 1):
			if (i == center.x) and (j == center.y):
				continue
			new_coord = IntCoord.new(i, j)
			if is_inside_dungeon(new_coord) and is_in_range(center, new_coord,
					max_range):
				neighbor.push_back(new_coord)
	if has_center:
		neighbor.push_back(center)
	return neighbor


static func get_block(top_left: IntCoord, width: int, height: int) -> Array:
	var new_coord: IntCoord
	var block_coords := []

	for i in range(top_left.x, top_left.x + width):
		for j in range(top_left.y, top_left.y + height):
			new_coord = IntCoord.new(i, j)
			if is_inside_dungeon(new_coord):
				block_coords.push_back(new_coord)
	return block_coords


static func get_mirror_image(source: IntCoord, center: IntCoord) -> IntCoord:
	var x := center.x * 2 - source.x
	var y := center.y * 2 - source.y
	return IntCoord.new(x, y)


static func is_inside_dungeon(coord: IntCoord) -> bool:
	return (coord.x >= 0) and (coord.x < DungeonSize.MAX_X) \
			and (coord.y >= 0) and (coord.y < DungeonSize.MAX_Y)


# Return: DirectionTag.[UP|DOWN|LEFT|RIGHT].
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


# ray_direction: DirectionTag.[UP|DOWN|LEFT|RIGHT].
# is_obstacle_func(x: int, y: int, opt_arg: Array) -> bool
# Return an array of coordinates: [IntCoord, ...].
static func get_ray_path(source_coord: IntCoord, max_range: int,
		ray_direction: int, has_start_point: bool, has_end_point: bool,
		func_host: Object, is_obstacle_func: String, opt_arg := []) -> Array:
	var x := source_coord.x
	var y := source_coord.y
	var is_obstacle := funcref(func_host, is_obstacle_func)
	var shift := DirectionTag.get_offset_by_direction(ray_direction)
	var new_coord: IntCoord
	var ray_path := []

	if has_start_point:
		ray_path.push_back(source_coord)
	for _i in range(0, max_range):
		x += shift.x
		y += shift.y
		new_coord = IntCoord.new(x, y)
		if not is_inside_dungeon(new_coord):
			return ray_path
		if is_obstacle.call_func(x, y, opt_arg):
			if has_end_point:
				ray_path.push_back(new_coord)
			return ray_path
		ray_path.push_back(new_coord)
	return ray_path


static func is_in_square(coord: IntCoord, center: IntCoord, half_size: int) \
		-> bool:
	for i in ["x", "y"]:
		if abs(coord[i] - center[i]) > half_size:
			return false
	return true


static func is_same_coord(this_coord: IntCoord, that_coord: IntCoord) -> bool:
	return (this_coord.x == that_coord.x) and (this_coord.y == that_coord.y)
