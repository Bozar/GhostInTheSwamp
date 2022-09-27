class_name PcCastRay


enum {
	FIRST_TAG,
	LAST_SPRITE,
}

const DUPLICATED_TAG := "Duplicated tag: %s"
const UNHANDLED_TAG := "Unhandled tag: %s"


# When PC stands on land, cast rays in four directions.
# Return: {DirectionTag: {FIRST_TAG, LAST_SPRITE}, ...}.
# By default, use PcCastRay as func_host.
# [land|swamp]_func(x: int, y: int, opt_arg: Array) -> bool
static func renew_world(func_host: Object, land_func := "_cast_from_land",
		swamp_func := "_cast_from_swamp") -> Dictionary:
	var cast_result := {}
	var pc_coord := FindObject.pc_coord
	var first_coord: IntCoord

	if not FindObjectHelper.has_land(pc_coord):
		return cast_result

	for i in DirectionTag.VALID_DIRECTIONS:
		# A ray is blocked in the first grid.
		if _block_by_neighbor(i, cast_result):
			continue
		first_coord = DirectionTag.get_coord_by_direction(pc_coord, i)
		# Keep casting the ray. Discard get_ray_path() output. Set cast_result
		# implicitly in _cast_from_[land|swamp]().
		match cast_result[i][FIRST_TAG]:
			SubTag.LAND:
				CoordCalculator.get_ray_path(first_coord, DungeonSize.MAX_X,
						i, false, true, func_host, land_func,
						[i, cast_result])
			SubTag.SWAMP:
				CoordCalculator.get_ray_path(first_coord, DungeonSize.MAX_X,
					i, false, true, func_host, swamp_func,
					[i, cast_result])
			_:
				push_warning(UNHANDLED_TAG % cast_result[i][FIRST_TAG])

	# Remove null values: rays that hit no sprite.
	for i in cast_result.keys():
		if cast_result[i][LAST_SPRITE] == null:
			cast_result.erase(i)
	return cast_result


static func _block_by_neighbor(direction: int, out_cast_result: Dictionary) \
		-> bool:
	var last_coord := DirectionTag.get_coord_by_direction(FindObject.pc_coord,
			direction)
	var last_sprite: Sprite
	var tag: String
	var save_tags := []

	# NO OUTPUT: PC is on an edge of the dungeon.
	if not CoordCalculator.is_inside_dungeon(last_coord):
		return true
	# NO OUTPUT: SubTag.SHRUB.
	elif FindObjectHelper.has_shrub(last_coord):
		return true
	# OUTPUT, BLOCK: SubTag.LAND + MainTag.ACTOR.
	elif FindObject.has_actor(last_coord):
		tag = _verify_tag(MainTag.ACTOR, save_tags)
		last_sprite = FindObject.get_actor(last_coord)
		out_cast_result[direction] = {
			FIRST_TAG: tag,
			LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, BLOCK: SubTag.SWAMP + SubTag.DINGHY.
	elif FindObjectHelper.has_dinghy(last_coord):
		tag = _verify_tag(SubTag.DINGHY, save_tags)
		last_sprite = FindObject.get_building(last_coord)
		out_cast_result[direction] = {
			FIRST_TAG: tag,
			LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, BLOCK: SubTag.HARBOR.
	elif FindObjectHelper.has_harbor(last_coord):
		tag = _verify_tag(SubTag.HARBOR, save_tags)
		last_sprite = FindObject.get_building(last_coord)
		if not (ObjectState.get_state(last_sprite) as HarborState).is_active:
			out_cast_result[direction] = {
				FIRST_TAG: tag,
				LAST_SPRITE: last_sprite,
			}
		return true
	# OUTPUT, BLOCK: SubTag.LAND + MainTag.TRAP.
	elif FindObject.has_trap(last_coord):
		tag = _verify_tag(MainTag.TRAP, save_tags)
		last_sprite = FindObject.get_trap(last_coord)
		out_cast_result[direction] = {
			FIRST_TAG: tag,
			LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, CONTINUE: SubTag.LAND.
	elif FindObjectHelper.has_land(last_coord):
		tag = _verify_tag(SubTag.LAND, save_tags)
		out_cast_result[direction] = {
			FIRST_TAG: tag,
			LAST_SPRITE: null,
		}
		return false
	# OUTPUT, CONTINUE: SubTag.SWAMP.
	else:
		tag = _verify_tag(SubTag.SWAMP, save_tags)
		out_cast_result[direction] = {
			FIRST_TAG: tag,
			LAST_SPRITE: null,
		}
		return false


static func _verify_tag(tag: String, out_save_tags: Array) -> String:
	if tag in out_save_tags:
		push_warning(DUPLICATED_TAG % tag)
	else:
		out_save_tags.push_back(tag)
	return tag


static func _cast_from_land(x: int, y: int, opt_arg: Array) -> bool:
	var direction: int = opt_arg[0]
	var out_cast_result: Dictionary = opt_arg[1]
	var coord := IntCoord.new(x, y)
	var last_sprite: Sprite

	# NO OUTPUT, BLOCK: SubTag.SWAMP.
	if FindObjectHelper.has_swamp(coord):
		return true
	# NO OUTPUT, BLOCK: MainTag.BUILDING.
	elif FindObject.has_building(coord):
		return true
	# OUTPUT, BLOCK: MainTag.ACTOR.
	# Since an actor cannot appear in swamp or building, the order does not
	# matter here.
	elif FindObject.has_actor(coord):
		last_sprite = FindObject.get_actor(coord)
		out_cast_result[direction][LAST_SPRITE] = last_sprite
		return true
	return false


static func _cast_from_swamp(x: int, y: int, opt_arg: Array) -> bool:
	var direction: int = opt_arg[0]
	var out_cast_result: Dictionary = opt_arg[1]
	var coord := IntCoord.new(x, y)
	var last_sprite: Sprite

	# OUTPUT, BLOCK: SubTag.HARBOR.
	# get_ray_path() can handle a pair of coords that is out of dungeon.
	if FindObjectHelper.has_harbor(coord):
		last_sprite = FindObjectHelper.get_harbor_with_coord(coord)
		out_cast_result[direction][LAST_SPRITE] = last_sprite
		return true
	# OUTPUT, BLOCK: MainTag.ACTOR.
	# An actor cannot enter a harbor, but must be on a land. So check actor
	# before land.
	elif FindObject.has_actor(coord):
		last_sprite = FindObject.get_actor(coord)
		out_cast_result[direction][LAST_SPRITE] = last_sprite
		return true
	# NO OUTPUT, BLOCK: SubTag.LAND or SubTag.SHRUB.
	elif FindObjectHelper.has_land(coord) or FindObjectHelper.has_shrub(coord):
		return true
	return false
