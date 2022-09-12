class_name Game_DirectionTag


const INVALID_DIRECTION := -99
const UP := 1
const DOWN := -1
const RIGHT := 2
const LEFT := -2

const DIRECTION_TO_SHIFT := {
	UP: [0, -1],
	DOWN: [0, 1],
	LEFT: [-1, 0],
	RIGHT: [1, 0],
}


static func is_opposite_direction(this_dir: int, that_dir: int) -> bool:
	return this_dir + that_dir == 0


static func get_opposite_direction(direction: int) -> int:
	return -direction


static func roate_clockwise(direction: int) -> int:
	if direction % 2 == 0:
		if direction > 0:
			return direction - 3
		return direction + 3
	return direction * 2


static func roate_counterclockwise(direction: int) -> int:
	return get_opposite_direction(roate_clockwise(direction))
