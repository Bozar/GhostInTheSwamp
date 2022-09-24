class_name PcCastRayHelper


static func cast_from_land(x: int, y: int, opt_arg: Array) -> bool:
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
		out_cast_result[direction][CastRayTag.LAST_SPRITE] = last_sprite
		return true
	return false


static func cast_from_swamp(x: int, y: int, opt_arg: Array) -> bool:
	var direction: int = opt_arg[0]
	var out_cast_result: Dictionary = opt_arg[1]
	var coord := IntCoord.new(x, y)
	var last_sprite: Sprite

	# OUTPUT, BLOCK: SubTag.HARBOR.
	# get_ray_path() can handle a pair of coords that is out of dungeon.
	if FindObjectHelper.has_harbor(coord):
		last_sprite = FindObjectHelper.get_harbor_with_coord(coord)
		out_cast_result[direction][CastRayTag.LAST_SPRITE] = last_sprite
		return true
	# OUTPUT, BLOCK: MainTag.ACTOR.
	# An actor cannot enter a harbor, but must be on a land. So check actor
	# before land.
	elif FindObject.has_actor(coord):
		last_sprite = FindObject.get_actor(coord)
		out_cast_result[direction][CastRayTag.LAST_SPRITE] = last_sprite
		return true
	# NO OUTPUT, BLOCK: SubTag.LAND or SubTag.SHRUB.
	elif FindObjectHelper.has_land(coord) or FindObjectHelper.has_shrub(coord):
		return true
	return false
