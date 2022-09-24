class_name PcCastRay


const DUPLICATED_TAG := "Duplicated tag: %s"
const UNHANDLED_TAG := "Unhandled tag: %s"


# When PC stands on land, cast rays in four directions.
# Return: {DirectionTag: {FIRST_TAG, LAST_SPRITE}, ...}.
static func renew_world() -> Dictionary:
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
		match cast_result[i][CastRayTag.FIRST_TAG]:
			SubTag.LAND:
				CoordCalculator.get_ray_path(first_coord, DungeonSize.MAX_X,
						i, false, true, PcCastRayHelper, "cast_from_land",
						[i, cast_result])
			SubTag.SWAMP:
				CoordCalculator.get_ray_path(first_coord, DungeonSize.MAX_X,
					i, false, true, PcCastRayHelper, "cast_from_swamp",
					[i, cast_result])
			_:
				push_warning(UNHANDLED_TAG % cast_result[i][CastRayTag.FIRST_TAG])

	# Remove null values: rays that hit no sprite.
	for i in cast_result.keys():
		if cast_result[i][CastRayTag.LAST_SPRITE] == null:
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
			CastRayTag.FIRST_TAG: tag,
			CastRayTag.LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, BLOCK: SubTag.SWAMP + SubTag.DINGHY.
	elif FindObjectHelper.has_dinghy(last_coord):
		tag = _verify_tag(SubTag.DINGHY, save_tags)
		last_sprite = FindObject.get_building(last_coord)
		out_cast_result[direction] = {
			CastRayTag.FIRST_TAG: tag,
			CastRayTag.LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, BLOCK: SubTag.HARBOR.
	elif FindObjectHelper.has_harbor(last_coord):
		tag = _verify_tag(SubTag.HARBOR, save_tags)
		last_sprite = FindObject.get_building(last_coord)
		if not (ObjectState.get_state(last_sprite) as HarborState).is_active:
			out_cast_result[direction] = {
				CastRayTag.FIRST_TAG: tag,
				CastRayTag.LAST_SPRITE: last_sprite,
			}
		return true
	# OUTPUT, BLOCK: SubTag.LAND + MainTag.TRAP.
	elif FindObject.has_trap(last_coord):
		tag = _verify_tag(MainTag.TRAP, save_tags)
		last_sprite = FindObject.get_trap(last_coord)
		out_cast_result[direction] = {
			CastRayTag.FIRST_TAG: tag,
			CastRayTag.LAST_SPRITE: last_sprite,
		}
		return true
	# OUTPUT, CONTINUE: SubTag.LAND.
	elif FindObjectHelper.has_land(last_coord):
		tag = _verify_tag(SubTag.LAND, save_tags)
		out_cast_result[direction] = {
			CastRayTag.FIRST_TAG: tag,
			CastRayTag.LAST_SPRITE: null,
		}
		return false
	# OUTPUT, CONTINUE: SubTag.SWAMP.
	else:
		tag = _verify_tag(SubTag.SWAMP, save_tags)
		out_cast_result[direction] = {
			CastRayTag.FIRST_TAG: tag,
			CastRayTag.LAST_SPRITE: null,
		}
		return false


static func _verify_tag(tag: String, out_save_tags: Array) -> String:
	if tag in out_save_tags:
		push_warning(DUPLICATED_TAG % tag)
	else:
		out_save_tags.push_back(tag)
	return tag
