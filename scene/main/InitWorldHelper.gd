extends Node2D
class_name Game_InitWorldHelper


const WARN_NO_NEIGHBOR := "[{0}, {1}] has no neighbor."

const PATH_TO_PREFAB := "res://resource/dungeon_prefab/"

const LAND_CHAR := "-"
const EXPAND_LAND_CHAR := "E"
const HARBOR_CHAR := "H"
const SHRUB_CHAR := "#"
const EXPAND_SHRUB_CHAR := "+"
const ISLAND_CHAR := "R"

const MAX_EXPAND := 3

var _ref_RandomNumber: Game_RandomNumber
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_CreateObject: Game_CreateObject


func init_ground_building() -> void:
	var packed_prefab: Game_DungeonPrefab.PackedPrefab
	var expand_coords := {
		EXPAND_LAND_CHAR: [],
		EXPAND_SHRUB_CHAR: [],
	}

	_set_reference()
	packed_prefab = _parse_prefab()

	# Land, harbor, shrub, island.
	_create_ground_building(packed_prefab, expand_coords)
	_create_expand_land(expand_coords[EXPAND_LAND_CHAR])
	_create_expand_shrub(expand_coords[EXPAND_SHRUB_CHAR])
	_create_swamp()


func _set_reference() -> void:
	_ref_RandomNumber = get_parent()._ref_RandomNumber
	_ref_DungeonBoard = get_parent()._ref_DungeonBoard
	_ref_CreateObject = get_parent()._ref_CreateObject


func _parse_prefab() -> Game_DungeonPrefab.PackedPrefab:
	var files := Game_FileIOHelper.get_file_list(PATH_TO_PREFAB)
	var path_to_file: String
	var edit_arg := [
			Game_DungeonPrefab.HORIZONTAL_FLIP,
			Game_DungeonPrefab.VERTICAL_FLIP
	]

	Game_ArrayHelper.rand_picker(files, 1, _ref_RandomNumber)
	path_to_file = PATH_TO_PREFAB + "test.txt"
	# path_to_file = files[0]
	for i in range(0, edit_arg.size()):
		if _ref_RandomNumber.get_percent_chance(50):
			edit_arg[i] = Game_DungeonPrefab.DO_NOT_EDIT
	return Game_DungeonPrefab.get_prefab(path_to_file, edit_arg)


func _create_ground_building(packed_prefab: Game_DungeonPrefab.PackedPrefab,
		out_expand_coords: Dictionary) -> void:
	var coord: Game_IntCoord

	for x in range(0, packed_prefab.max_x):
		for y in range(0, packed_prefab.max_y):
			coord = Game_IntCoord.new(x, y)
			match packed_prefab.prefab[x][y]:
				LAND_CHAR:
					_ref_CreateObject.create_ground(Game_SubTag.LAND, coord)
				HARBOR_CHAR:
					_ref_CreateObject.create_building(Game_SubTag.HARBOR, coord)
				SHRUB_CHAR:
					_ref_CreateObject.create_building(Game_SubTag.SHRUB, coord)
				ISLAND_CHAR:
					_ref_CreateObject.create_building(Game_SubTag.ISLAND, coord)
				EXPAND_LAND_CHAR:
					out_expand_coords[EXPAND_LAND_CHAR].push_back(coord)
				EXPAND_SHRUB_CHAR:
					out_expand_coords[EXPAND_SHRUB_CHAR].push_back(coord)
				_:
					pass


func _create_swamp() -> void:
	var all_coords := []

	Game_DungeonSize.init_all_coords(all_coords)
	for i in all_coords:
		if _ref_DungeonBoard.has_ground(i) or _ref_DungeonBoard.has_building(i):
			continue
		_ref_CreateObject.create_ground(Game_SubTag.SWAMP, i)


func _create_expand_land(expand_coords: Array) -> void:
	var target_coord: Game_IntCoord
	var ray_direction: int
	var max_length: int
	var new_coords: Array

	for i in expand_coords:
		target_coord = _get_target_coord(i)
		if target_coord == null:
			continue
		ray_direction = Game_CoordCalculator.get_ray_direction(i, target_coord)
		max_length = _ref_RandomNumber.get_int(0, MAX_EXPAND)
		new_coords = Game_CoordCalculator.get_ray_path(i, max_length,
				ray_direction, true, false, self, "_is_ray_obstacle")
		for nc in new_coords:
			_ref_CreateObject.create_ground(Game_SubTag.LAND, nc)


func _get_target_coord(coord: Game_IntCoord) -> Game_IntCoord:
	var neighbor := Game_CoordCalculator.get_neighbor(coord, 1)

	for i in neighbor:
		if _ref_DungeonBoard.has_sprite(Game_MainTag.GROUND, i):
			return Game_CoordCalculator.get_mirror_image(coord, i)
	push_warning(WARN_NO_NEIGHBOR.format([coord.x, coord.y]))
	return null


func _is_ray_obstacle(_x: int, _y: int, _opt: Array) -> bool:
	return false


func _create_expand_shrub(expand_coords: Array) -> void:
	var half_size := int(floor(expand_coords.size() / 2.0))

	Game_ArrayHelper.rand_picker(expand_coords, half_size, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(Game_SubTag.SHRUB, i)
