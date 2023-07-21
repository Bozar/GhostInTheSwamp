class_name ConvertCoord


const START_X: int = 50
const START_Y: int = 54
const STEP_X: int = 26
const STEP_Y: int = 34

const MOUSE_START_X := START_X - 10
const MOUSE_START_Y := START_Y - 10

const MIN_HASH_INPUT: int = 0
const MAX_HASH_INPUT: int = 99
const INVALID_HASH_COORD: int = -1

const MAIN_TAG_TO_INT := {
	MainTag.GROUND: 1,
	MainTag.TRAP: 2,
	MainTag.BUILDING: 3,
	MainTag.ACTOR: 4,
	MainTag.INDICATOR: 5,
}


static func sprite_to_coord(this_sprite: Sprite) -> IntCoord:
	return vector_to_coord(this_sprite.position)


static func vector_to_coord(vector_coord: Vector2) -> IntCoord:
	var x := int((vector_coord.x - START_X) / STEP_X)
	var y := int((vector_coord.y - START_Y) / STEP_Y)

	return IntCoord.new(x, y)


static func mouse_to_coord(mouse_event: InputEvent) -> IntCoord:
	var x := int((mouse_event.position.x - MOUSE_START_X) / STEP_X)
	var y := int((mouse_event.position.y - MOUSE_START_Y) / STEP_Y)

	return IntCoord.new(x, y)


static func coord_to_vector(coord: IntCoord, x_offset: int = 0,
		y_offset: int = 0) -> Vector2:
	var x_vector := START_X + STEP_X * coord.x + x_offset
	var y_vector := START_Y + STEP_Y * coord.y + y_offset
	return Vector2(x_vector, y_vector)


# Add Z index if necessary.
static func hash_coord(coord: IntCoord, main_tag := "", z_index: int = 0) -> int:
	if not _is_valid_hash_input([coord.x, coord.y, z_index]):
		return INVALID_HASH_COORD

	# 543210
	# ZMYYXX | z_index, main_tag, coord.y, coord.x
	var x := coord.x
	var y := coord.y * pow(10, 2)
	var hash_tag: int = MAIN_TAG_TO_INT.get(main_tag, 0) * pow(10, 4)
	var hash_layer := z_index * pow(10, 5)
	return int(x + y + hash_tag + hash_layer)


static func _is_valid_hash_input(inputs: Array) -> bool:
	for i in inputs:
		if (i < MIN_HASH_INPUT) or (i > MAX_HASH_INPUT):
			return false
	return true
