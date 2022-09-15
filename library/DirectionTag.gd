class_name DirectionTag


const INVALID_DIRECTION := -99
const NO_DIRECTION := 0
const UP := 1
const RIGHT := 2
const DOWN := -1
const LEFT := -2

const MAX_POSITIVE_DIRECTION := 2
const MIN_POSITIVE_DIRECTION := 1

const VALID_DIRECTIONS := [UP, DOWN, LEFT, RIGHT,]

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
	var new_direction: int

	if direction > 0:
		new_direction = direction + 1
		if new_direction > MAX_POSITIVE_DIRECTION:
			return -MIN_POSITIVE_DIRECTION
		return new_direction
	elif direction < 0:
		new_direction = direction - 1
		if new_direction < -MAX_POSITIVE_DIRECTION:
			return MIN_POSITIVE_DIRECTION
		return new_direction
	return direction


static func roate_counterclockwise(direction: int) -> int:
	return get_opposite_direction(roate_clockwise(direction))
