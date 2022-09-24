class_name FindObjectHelper


static func has_swamp(coord: IntCoord) -> bool:
	return FindObject.has_ground_with_sub_tag(coord, SubTag.SWAMP)


static func has_land(coord: IntCoord) -> bool:
	return FindObject.has_ground_with_sub_tag(coord, SubTag.LAND)


static func has_harbor(coord: IntCoord) -> bool:
	return FindObject.has_building_with_sub_tag(coord, SubTag.HARBOR)


static func has_land_or_harbor(coord: IntCoord) -> bool:
	return has_land(coord) or has_harbor(coord)


static func has_shrub(coord: IntCoord) -> bool:
	return FindObject.has_building_with_sub_tag(coord, SubTag.SHRUB)


static func has_unoccupied_land(coord: IntCoord) -> bool:
	return (not FindObject.has_actor(coord)) and has_land(coord)


static func has_final_harbor(coord: IntCoord) -> bool:
	return FindObject.has_building_with_sub_tag(coord, SubTag.FINAL_HARBOR)


static func has_ship(coord: IntCoord) -> bool:
	return FindObject.has_building_with_sub_tag(coord, SubTag.SHIP)


static func has_dinghy(coord: IntCoord) -> bool:
	return FindObject.has_building_with_sub_tag(coord, SubTag.DINGHY)


static func get_harbors() -> Array:
	return FindObject.get_sprites_with_tag(SubTag.HARBOR)


static func get_harbor_with_coord(coord: IntCoord) -> Sprite:
	return FindObject.get_building_with_sub_tag(coord, SubTag.HARBOR)
