extends Node2D
class_name SpawnActor


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
	NodeTag.RANDOM_NUMBER,
]

var _ref_CreateObject: CreateObject
var _ref_RandomNumber: RandomNumber

var _land_coords: Array
var _count_actor := {
	SubTag.SCOUT: ActorData.INITIAL_SCOUT,
	SubTag.ENGINEER: ActorData.INITIAL_ENGINEER,
	SubTag.PERFORMER: ActorData.INITIAL_PERFORMER,
}
var _max_actor := ActorData.INITIAL_MAX_ACTOR
var _count_item := 0


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)

	_set_land_coords()
	_create_tourist()


func renew_world() -> void:
	var create_result: Array
	var sub_tag: String

	if FindObject.get_npc_count() < _max_actor:
		_set_count_actor()
		sub_tag = _ref_RandomNumber.get_weighted_chance(_count_actor,
				SubTag.INVALID)
		create_result = [sub_tag, false]
		_create_actor(create_result)
		if create_result[1]:
			_count_actor[sub_tag] -= 1


func remove_actor(remove_sprite: Sprite) -> void:
	var state: ActorState

	if not remove_sprite.is_in_group(MainTag.ACTOR):
		return
	elif remove_sprite.is_in_group(SubTag.TOURIST):
		return
	state = ObjectState.get_state(remove_sprite)
	_count_actor[state.sub_tag] += 1


func _set_count_actor() -> void:
	while _count_item < FindObject.pc_state.count_item:
		_count_item += 1
		match _count_item:
			1:
				_max_actor += ActorData.ADD_ACTOR
				_count_actor[SubTag.PERFORMER] += ActorData.ADD_ACTOR
			# 3:
			# 	for i in _count_actor.keys():
			# 		_max_actor += ActorData.ADD_ACTOR
			# 		_count_actor[i] += ActorData.ADD_ACTOR


func _create_tourist() -> void:
	WorldGenerator.create_by_coord(_land_coords, _max_actor,
			_ref_RandomNumber, self, "_is_valid_coord", [],
			"_create_tourist_here", [], _max_actor - 1)


func _create_actor(out_create_result: Array) -> void:
	WorldGenerator.create_by_coord(_land_coords, 1,
			_ref_RandomNumber, self, "_is_valid_coord", [],
			"_create_actor_here", out_create_result, 0)


func _set_land_coords() -> void:
	_land_coords = FindObjectHelper.get_common_land_coords()


func _is_valid_coord(coord: IntCoord, _retry: int, _opt: Array) -> bool:
	var pc_coord := FindObject.pc_coord

	if CoordCalculator.is_in_range(coord, pc_coord, ActorData.MIN_DISTANCE_TO_PC):
		return false
	for i in FindObject.get_sprites_with_tag(MainTag.ACTOR):
		if CoordCalculator.is_in_range(coord, ConvertCoord.sprite_to_coord(i),
				ActorData.MIN_DISTANCE_TO_ACTOR):
			return false
	return true


func _create_tourist_here(coord: IntCoord, _opt: Array) -> void:
	_ref_CreateObject.create_actor(SubTag.TOURIST, coord)


# opt_arg := [sub_tag: String, create_success: bool]
func _create_actor_here(coord: IntCoord, opt_arg: Array) -> void:
	_ref_CreateObject.create_actor(opt_arg[0], coord)
	opt_arg[1] = true
