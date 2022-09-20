extends Node2D
class_name InitWorldHelper


const REF_VARS := [
	NodeTag.RANDOM_NUMBER, NodeTag.CREATE_OBJECT,
]
const PATH_TO_PREFAB := "res://resource/dungeon_prefab/"

const NO_NEIGHBOR := "[%s, %s] has no neighbor."

const LAND_CHAR := "-"
const EXPAND_LAND_CHAR := "E"
const HARBOR_CHAR := "h"
const EXPAND_HARBOR_CHAR := "H"
const SHRUB_CHAR := "#"
const EXPAND_SHRUB_CHAR := "+"
const ISLAND_CHAR := "R"

const MAX_EXPAND := 3
const MAX_HARBOR := 4

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func init_ground_building() -> void:
	var packed_prefab := _parse_prefab()
	var expand_coords := {
		EXPAND_LAND_CHAR: [],
		EXPAND_SHRUB_CHAR: [],
		EXPAND_HARBOR_CHAR: [],
	}

	# Land, harbor, shrub, island.
	_create_ground_building(packed_prefab, expand_coords)
	_create_expand_land(expand_coords[EXPAND_LAND_CHAR])
	_create_expand_shrub(expand_coords[EXPAND_SHRUB_CHAR])
	_create_expand_harbor(expand_coords[EXPAND_HARBOR_CHAR])
	_create_swamp()


func _parse_prefab() -> DungeonPrefab.PackedPrefab:
	var files := FileIoHelper.get_file_list(PATH_TO_PREFAB)
	var path_to_file: String
	var edit_arg := [
			DungeonPrefab.HORIZONTAL_FLIP,
			DungeonPrefab.VERTICAL_FLIP
	]

	ArrayHelper.rand_picker(files, 1, _ref_RandomNumber)
	path_to_file = PATH_TO_PREFAB + "test.txt"
	# path_to_file = files[0]
	for i in range(0, edit_arg.size()):
		if _ref_RandomNumber.get_percent_chance(50):
			edit_arg[i] = DungeonPrefab.DO_NOT_EDIT
	return DungeonPrefab.get_prefab(path_to_file, edit_arg)


func _create_ground_building(packed_prefab: DungeonPrefab.PackedPrefab,
		out_expand_coords: Dictionary) -> void:
	var coord: IntCoord

	for x in range(0, packed_prefab.max_x):
		for y in range(0, packed_prefab.max_y):
			coord = IntCoord.new(x, y)
			match packed_prefab.prefab[x][y]:
				LAND_CHAR:
					_ref_CreateObject.create_ground(SubTag.LAND, coord)
				HARBOR_CHAR:
					_ref_CreateObject.create_building(SubTag.HARBOR, coord)
				SHRUB_CHAR:
					_ref_CreateObject.create_building(SubTag.SHRUB, coord)
				ISLAND_CHAR:
					_ref_CreateObject.create_building(SubTag.ISLAND, coord)
				EXPAND_LAND_CHAR:
					out_expand_coords[EXPAND_LAND_CHAR].push_back(coord)
				EXPAND_SHRUB_CHAR:
					out_expand_coords[EXPAND_SHRUB_CHAR].push_back(coord)
				EXPAND_HARBOR_CHAR:
					out_expand_coords[EXPAND_HARBOR_CHAR].push_back(coord)
				_:
					pass


func _create_swamp() -> void:
	var all_coords := []

	DungeonSize.init_all_coords(all_coords)
	for i in all_coords:
		if FindObject.has_ground(i) or FindObject.has_building(i):
			continue
		_ref_CreateObject.create_ground(SubTag.SWAMP, i)


func _create_expand_land(expand_coords: Array) -> void:
	var land_coord: IntCoord
	var ray_direction: int
	var max_length: int
	var new_coords: Array

	for i in expand_coords:
		land_coord = _get_land_coord(i)
		if land_coord == null:
			continue
		ray_direction = CoordCalculator.get_ray_direction(land_coord, i)
		max_length = _ref_RandomNumber.get_int(0, MAX_EXPAND)
		new_coords = CoordCalculator.get_ray_path(i, max_length,
				ray_direction, true, false, self, "_is_ray_obstacle")
		for nc in new_coords:
			_ref_CreateObject.create_ground(SubTag.LAND, nc)


func _get_land_coord(coord: IntCoord) -> IntCoord:
	var neighbor := CoordCalculator.get_neighbor(coord, 1)

	for i in neighbor:
		if FindObject.has_ground(i):
			return i
	push_warning(NO_NEIGHBOR % [coord.x, coord.y])
	return null


func _is_ray_obstacle(_x: int, _y: int, _opt: Array) -> bool:
	return false


func _create_expand_shrub(expand_coords: Array) -> void:
	var half_size := expand_coords.size() / 2

	ArrayHelper.rand_picker(expand_coords, half_size, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(SubTag.SHRUB, i)


func _create_expand_harbor(expand_coords: Array) -> void:
	if expand_coords.size() > MAX_HARBOR:
		ArrayHelper.rand_picker(expand_coords, MAX_HARBOR, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(SubTag.HARBOR, i)
