extends Node2D
class_name InitWorldHelper


const PATH_TO_PREFAB := "res://resource/dungeon_prefab/"
const PATH_TO_A0 := PATH_TO_PREFAB + "a0/"
const PATH_TO_A1 := PATH_TO_PREFAB + "a1/"
const PATH_TO_A2 := PATH_TO_PREFAB + "a2/"
const PATH_TO_B0 := PATH_TO_PREFAB + "b0/"
const PATH_TO_B1 := PATH_TO_PREFAB + "b1/"
const PATH_TO_B2 := PATH_TO_PREFAB + "b2/"
const PATH_TO_C0 := PATH_TO_PREFAB + "c0/"
const PATH_TO_C1 := PATH_TO_PREFAB + "c1/"
const PATH_TO_C2 := PATH_TO_PREFAB + "c2/"
# Split the dungeon into ROW x COLUMN zones.
const ROW_TO_PATH := {
	0: [PATH_TO_A0, PATH_TO_A1, PATH_TO_A2,],
	1: [PATH_TO_B0, PATH_TO_B1, PATH_TO_B2,],
	2: [PATH_TO_C0, PATH_TO_C1, PATH_TO_C2,],
}

const NO_NEIGHBOR := "[%s, %s] has no neighbor."

const LAND_CHAR := "-"
const FAR_LAND_CHAR := "F"
const EXPAND_LAND_CHAR := "E"
const EXPAND_DIRECTION_CHAR := "X"
const LAND_MARK_CHAR := "="
const HARBOR_CHAR := "H"
const FINAL_HARBOR_CHAR := "r"
const SHRUB_CHAR := "#"
const EXPAND_SHRUB_CHAR := "+"
const ISLAND_CHAR := "R"

const MAX_EXPAND: int = 3

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject


func init_ground_building() -> void:
	var packed_prefab := _parse_prefab()
	var record_coords := {
		EXPAND_LAND_CHAR: [],
		EXPAND_SHRUB_CHAR: [],
		EXPAND_DIRECTION_CHAR: [],
		LAND_MARK_CHAR: [],
	}

	# Land, harbor, shrub, island.
	_create_ground_building(packed_prefab, record_coords)
	_create_expand_land(record_coords)
	_create_expand_shrub(record_coords)
	_create_swamp()

	_set_land_mark_sprite(record_coords)


func _parse_prefab() -> DungeonPrefab.PackedPrefab:
	# return _parse_full_map()

	var row_to_prefab := {}
	var file_list: Array
	var read_file: FileParser
	var combined_file: FileParser
	var edit_arg: Array = _get_edit_arg()

	# row: int
	for row in ROW_TO_PATH.keys():
		# column: int
		for column in range(0, ROW_TO_PATH[row].size()):
			# Select one file for a specific dungeon zone.
			file_list = FileIoHelper.get_file_list(ROW_TO_PATH[row][column])
			ArrayHelper.rand_picker(file_list, 1, _ref_RandomNumber)
			print(file_list[0].get_file())
			# Leave the first zone in a row unchanged.
			if column == 0:
				combined_file = FileIoHelper.read_as_line(file_list[0])
			# Append following zones into the first one.
			else:
				read_file = FileIoHelper.read_as_line(file_list[0])
				FileIoHelper.append_column(combined_file, read_file)
		# One file parser per row.
		row_to_prefab[row] = combined_file

	# row: int
	for row in range(0, row_to_prefab.size()):
		# Leave the first zone unchanged.
		if row == 0:
			combined_file = row_to_prefab[row]
		# Append following zones into the first one by ascending order.
		else:
			FileIoHelper.append_row(combined_file, row_to_prefab[row])

	return DungeonPrefab.get_prefab(combined_file.output_line, edit_arg)


func _get_edit_arg() -> Array:
	var edit_arg := [
		DungeonPrefab.HORIZONTAL_FLIP,
		DungeonPrefab.VERTICAL_FLIP,
	]

	for i in range(0, edit_arg.size()):
		if _ref_RandomNumber.get_percent_chance(50):
			edit_arg[i] = DungeonPrefab.DO_NOT_EDIT
	return edit_arg


func _create_ground_building(packed_prefab: DungeonPrefab.PackedPrefab,
		out_record_coords: Dictionary) -> void:
	var coord: IntCoord

	for x in range(0, packed_prefab.max_x):
		for y in range(0, packed_prefab.max_y):
			coord = IntCoord.new(x, y)
			match packed_prefab.prefab[x][y]:
				LAND_CHAR:
					_ref_CreateObject.create_ground(SubTag.LAND, coord)
				FAR_LAND_CHAR:
					_ref_CreateObject.create_ground(SubTag.LAND, coord,
							[SubTag.FAR_LAND])
				LAND_MARK_CHAR:
					_ref_CreateObject.create_ground(SubTag.LAND, coord)
					out_record_coords[LAND_MARK_CHAR].push_back(coord)
				HARBOR_CHAR:
					_ref_CreateObject.create_building(SubTag.HARBOR, coord)
				FINAL_HARBOR_CHAR:
					_ref_CreateObject.create_building(SubTag.HARBOR, coord,
							[SubTag.FINAL_HARBOR])
				SHRUB_CHAR:
					_ref_CreateObject.create_building(SubTag.SHRUB, coord)
				ISLAND_CHAR:
					_ref_CreateObject.create_building(SubTag.ISLAND, coord)
				EXPAND_LAND_CHAR:
					out_record_coords[EXPAND_LAND_CHAR].push_back(coord)
				EXPAND_DIRECTION_CHAR:
					out_record_coords[EXPAND_DIRECTION_CHAR].push_back(
							ConvertCoord.hash_coord(coord))
				EXPAND_SHRUB_CHAR:
					out_record_coords[EXPAND_SHRUB_CHAR].push_back(coord)
				_:
					pass


func _create_swamp() -> void:
	var all_coords := []

	DungeonSize.init_all_coords(all_coords)
	for i in all_coords:
		if FindObject.has_ground(i) or FindObject.has_building(i):
			continue
		_ref_CreateObject.create_ground(SubTag.SWAMP, i)


func _create_expand_land(record_coords: Dictionary) -> void:
	var expand_coords: Array = record_coords[EXPAND_LAND_CHAR]
	var expand_directions: Array = record_coords[EXPAND_DIRECTION_CHAR]
	var land_mark_coords: Array = record_coords[LAND_MARK_CHAR]
	var land_coord: IntCoord
	var ray_direction: int
	var max_length: int
	var new_coords: Array

	for ec in expand_coords:
		land_coord = _get_land_coord(ec, expand_directions)
		if land_coord == null:
			continue
		ray_direction = CoordCalculator.get_ray_direction(ec, land_coord)
		max_length = _ref_RandomNumber.get_int(0, MAX_EXPAND)
		new_coords = CoordCalculator.get_ray_path(ec, max_length,
				ray_direction, true, false, self, "_is_ray_obstacle")
		for i in range(0, new_coords.size()):
			if i == MAX_EXPAND - 1:
				land_mark_coords.push_back(new_coords[i])
			_ref_CreateObject.create_ground(SubTag.LAND, new_coords[i])


func _get_land_coord(coord: IntCoord, directions: Array) -> IntCoord:
	var coord_index: int

	for i in CoordCalculator.get_neighbor(coord, 1):
		coord_index = directions.find(ConvertCoord.hash_coord(i))
		if coord_index > -1:
			ArrayHelper.remove_by_index(directions, coord_index)
			return i
	push_warning(NO_NEIGHBOR % [coord.x, coord.y])
	return null


func _is_ray_obstacle(_x: int, _y: int, _opt: Array) -> bool:
	return false


func _create_expand_shrub(record_coords: Dictionary) -> void:
	var expand_coords: Array = record_coords[EXPAND_SHRUB_CHAR]
	var half_size: int = expand_coords.size() / 2

	ArrayHelper.rand_picker(expand_coords, half_size, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(SubTag.SHRUB, i)


func _parse_full_map() -> DungeonPrefab.PackedPrefab:
	var path_to_file: String = PATH_TO_PREFAB + "test.txt"
	var read_file: FileParser = FileIoHelper.read_as_line(path_to_file)
	var edit_arg: Array = _get_edit_arg()
	return DungeonPrefab.get_prefab(read_file.output_line, edit_arg)


func _set_land_mark_sprite(record_coords: Dictionary) -> void:
	for i in record_coords[LAND_MARK_CHAR]:
		SwitchSprite.set_sprite(FindObject.get_ground(i), SpriteTag.ACTIVE)
