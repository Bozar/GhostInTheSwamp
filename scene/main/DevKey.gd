extends Node2D
class_name DevKey


func test() -> void:
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
