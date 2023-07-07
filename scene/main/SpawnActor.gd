extends Node2D
class_name SpawnActor


var _ref_CreateObject: CreateObject
var _ref_RandomNumber: RandomNumber

var _land_coords: Array
var _count_actor := {
	SubTag.SCOUT: ActorData.MAX_SCOUT,
	SubTag.ENGINEER: ActorData.MAX_ENGINEER,
	SubTag.PERFORMER: ActorData.MAX_PERFORMER,
}


func set_reference() -> void:
	_set_land_coords()
	_create_tourist()


func renew_world() -> void:
	var create_result: Array
	var sub_tag: String

	if FindObject.get_npc_count() < ActorData.MAX_ACTOR:
		sub_tag = _ref_RandomNumber.get_weighted_chance(_count_actor,
				SubTag.INVALID)
		create_result = [sub_tag, false]
		_create_actor(create_result)
		if create_result[1]:
			_count_actor[sub_tag] -= 1


func remove_actor(remove_sprite: Sprite) -> void:
	if remove_sprite.is_in_group(SubTag.TOURIST):
		return

	var sub_tag: String = ObjectState.get_state(remove_sprite).sub_tag
	var count_item: int = FindObject.pc_state.count_item

	# When PC has collected all items, replace scouts with performers.
	if (sub_tag == SubTag.SCOUT) and (count_item == PcData.MAX_ITEM):
		sub_tag = SubTag.PERFORMER
	_count_actor[sub_tag] += 1


func _create_tourist() -> void:
	WorldGenerator.create_by_coord(_land_coords, ActorData.MAX_ACTOR,
			_ref_RandomNumber, self, "_is_valid_coord", [],
			"_create_tourist_here", [], ActorData.MAX_ACTOR - 1)


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
