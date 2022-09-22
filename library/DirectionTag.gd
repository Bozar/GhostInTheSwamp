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

const DIRECTION_TO_SPRITE := {
	UP: SpriteTag.UP,
	RIGHT: SpriteTag.RIGHT,
	DOWN: SpriteTag.DOWN,
	LEFT: SpriteTag.LEFT,
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


static func get_coord_by_direction(coord: IntCoord, direction_tag: int,
		step := 1) -> IntCoord:
	var offset := get_offset_by_direction(direction_tag, step)
	return IntCoord.new(coord.x + offset.x, coord.y + offset.y)


static func get_offset_by_direction(direction_tag: int, step := 1) -> IntCoord:
	var x_offset := 0
	var y_offset := 0

	match direction_tag:
		DOWN:
			y_offset = 1
		UP:
			y_offset = -1
		RIGHT:
			x_offset = 1
		LEFT:
			x_offset = -1
		_:
			pass
	return IntCoord.new(x_offset * step, y_offset * step)


static func get_sprite_by_direction(direction_tag: int) -> String:
	return DIRECTION_TO_SPRITE.get(direction_tag, SpriteTag.NO_DIRECTION)
