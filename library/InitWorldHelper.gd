extends Node2D
class_name InitWorldHelper


const NO_NEIGHBOR := "[%s, %s] has no neighbor."

const PATH_TO_PREFAB := "res://resource/dungeon_prefab/"

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

var _hash_terrain := {}


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

	_hash_terrain.clear()


func on_sprite_created(sprite_data: BasicSpriteData) -> void:
	var this_tag := sprite_data.main_tag
	var hash_coord := ConvertCoord.hash_coord(sprite_data.coord)

	if (this_tag == MainTag.BUILDING) or (this_tag == MainTag.GROUND):
		_hash_terrain[hash_coord] = this_tag


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
	var hash_coord: int

	DungeonSize.init_all_coords(all_coords)
	for i in all_coords:
		hash_coord = ConvertCoord.hash_coord(i)
		# Has ground or building.
		if _hash_terrain.has(hash_coord):
			continue
		_ref_CreateObject.create_ground(SubTag.SWAMP, i)


func _create_expand_land(expand_coords: Array) -> void:
	var target_coord: IntCoord
	var ray_direction: int
	var max_length: int
	var new_coords: Array

	for i in expand_coords:
		target_coord = _get_target_coord(i)
		if target_coord == null:
			continue
		ray_direction = CoordCalculator.get_ray_direction(i, target_coord)
		max_length = _ref_RandomNumber.get_int(0, MAX_EXPAND)
		new_coords = CoordCalculator.get_ray_path(i, max_length,
				ray_direction, true, false, self, "_is_ray_obstacle")
		for nc in new_coords:
			_ref_CreateObject.create_ground(SubTag.LAND, nc)


func _get_target_coord(coord: IntCoord) -> IntCoord:
	var neighbor := CoordCalculator.get_neighbor(coord, 1)
	var hash_coord: int

	for i in neighbor:
		hash_coord = ConvertCoord.hash_coord(i)
		if _hash_terrain.get(hash_coord, "") == MainTag.GROUND:
			return CoordCalculator.get_mirror_image(coord, i)
	push_warning(NO_NEIGHBOR % [coord.x, coord.y])
	return null


func _is_ray_obstacle(_x: int, _y: int, _opt: Array) -> bool:
	return false


func _create_expand_shrub(expand_coords: Array) -> void:
	var half_size := int(floor(expand_coords.size() / 2.0))

	ArrayHelper.rand_picker(expand_coords, half_size, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(SubTag.SHRUB, i)


func _create_expand_harbor(expand_coords: Array) -> void:
	if expand_coords.size() > MAX_HARBOR:
		ArrayHelper.rand_picker(expand_coords, MAX_HARBOR, _ref_RandomNumber)
	for i in expand_coords:
		_ref_CreateObject.create_building(SubTag.HARBOR, i)
