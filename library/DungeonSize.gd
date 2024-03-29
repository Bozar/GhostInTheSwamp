class_name DungeonSize


const MAX_X: int = 21
const MAX_Y: int = 15

const CENTER_X: int = 10
const CENTER_Y: int = 7

const ARROW_MARGIN: int = 32


static func init_dungeon_grids(out_dungeon: Dictionary, init_value = null,
		init_once := true) -> void:
	var is_empty := out_dungeon.size() < 1

	if (not is_empty) and init_once:
		return

	for x in range(0, MAX_X):
		if is_empty:
			out_dungeon[x] = []
			out_dungeon[x].resize(MAX_Y)
		if init_value != null:
			for y in range(0, MAX_Y):
				out_dungeon[x][y] = init_value


# get_init_value_func(x: int, y: int, optional_arg: Array)
# Return an initial value for dungeon[x][y].
static func init_dungeon_grids_by_func(out_dungeon: Dictionary,
		func_host: Object, get_init_value_func: String, optional_arg := [],
		init_once := true) -> void:
	var is_empty := out_dungeon.size() < 1
	var get_init_value := funcref(func_host, get_init_value_func)

	if (not is_empty) and init_once:
		return

	for x in range(0, MAX_X):
		if is_empty:
			out_dungeon[x] = []
			out_dungeon[x].resize(MAX_Y)
		for y in range(0, MAX_Y):
			out_dungeon[x][y] = get_init_value.call_func(x, y, optional_arg)


static func init_all_coords(out_coords: Array) -> void:
	var row: int = 0

	out_coords.resize(MAX_X * MAX_Y)
	for x in range(0, MAX_X):
		for y in range(0, MAX_Y):
			out_coords[x + y + row] = IntCoord.new(x, y)
		# Every row has (MAX_Y - 1) elements.
		row += MAX_Y - 1
