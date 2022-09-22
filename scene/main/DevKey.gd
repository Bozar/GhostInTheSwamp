extends Node2D
class_name DevKey


func test() -> void:
	_add_item(SubTag.RUM)
	pass


# 0: near land, 1: anywhere, 2: final harbor
func _teleport(destination: int) -> void:
	var coord: IntCoord

	match destination:
		0:
			for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
				if FindObject.has_ground_with_sub_tag(i, SubTag.SWAMP):
					coord = i
					break
		1:
			coord = get_parent()._ref_RandomNumber.get_dungeon_coord()
		2:
			coord = ConvertCoord.sprite_to_coord(
					FindObject.get_sprites_with_tag(SubTag.FINAL_HARBOR)[0])

	MoveObject.move(FindObject.pc, coord)
	get_parent()._end_turn()


func _add_dinghy(coord: IntCoord) -> void:
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, get_parent()._ref_RandomNumber)
	get_parent()._ref_CreateObject.create_building(SubTag.DINGHY,
			ground_coords[0])


func _add_item(sub_tag: String) -> void:
	var pc_coord := ConvertCoord.sprite_to_coord(FindObject.pc)
	get_parent()._ref_CreateObject.create_trap(sub_tag,
			IntCoord.new(pc_coord.x - 1, pc_coord.y))
