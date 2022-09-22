extends Node2D
class_name DevKey


func test() -> void:
	var p := get_parent()
	_add_actor(SubTag.PERFORMER)
	p._pc_state.set_npc_sight(DirectionTag.RIGHT, true)
	p._end_turn()
	# _add_actor(SubTag.PERFORMER)
	pass


# 0: near land, 1: anywhere, 2: final harbor
func _teleport(destination: int) -> void:
	var p := get_parent()
	var coord: IntCoord

	match destination:
		0:
			for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
				if FindObject.has_ground_with_sub_tag(i, SubTag.SWAMP):
					coord = i
					break
		1:
			coord = p._ref_RandomNumber.get_dungeon_coord()
		2:
			coord = ConvertCoord.sprite_to_coord(FindObject.get_sprites_with_tag(
					SubTag.FINAL_HARBOR)[0])

	MoveObject.move(FindObject.pc, coord)
	p._end_turn()


func _add_dinghy(coord: IntCoord) -> void:
	var p := get_parent()
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, p._ref_RandomNumber)
	p._ref_CreateObject.create_building(SubTag.DINGHY, ground_coords[0])


func _add_item(sub_tag: String) -> void:
	var p := get_parent()
	var coord := ConvertCoord.sprite_to_coord(FindObject.pc)

	p._ref_CreateObject.create_trap(sub_tag, IntCoord.new(coord.x - 1, coord.y))


func _add_actor(sub_tag: String) -> void:
	var p := get_parent()
	var coord := ConvertCoord.sprite_to_coord(FindObject.pc)
	var actor: Sprite = p._ref_CreateObject.create_and_fetch(MainTag.ACTOR,
			sub_tag, IntCoord.new(coord.x - 1, coord.y))

	ObjectState.get_state(actor).face_direction = DirectionTag.LEFT
