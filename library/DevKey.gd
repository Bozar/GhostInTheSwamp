class_name DevKey


static func test(n: Node2D) -> void:
	# var sub_tags := [
	# 	SubTag.TOURIST,
	# 	SubTag.SCOUT,
	# 	SubTag.ENGINEER,
	# 	SubTag.PERFORMER
	# ]
	# ArrayHelper.shuffle(sub_tags, n._ref_RandomNumber)
	# _add_actor(sub_tags[0], -1, 0, n)
	# ArrayHelper.shuffle(sub_tags, n._ref_RandomNumber)
	# _add_actor(sub_tags[0], 2, 0, n)
	# _add_item(2, n)
	# MoveObject.move(FindObject.pc, IntCoord.new(FindObject.pc_coord.x,
	# 		FindObject.pc_coord.y - 1))
	# _add_dinghy(FindObject.pc_coord, n)
	_teleport(2, n)
	# n._end_turn()
	return


# 0: near land, 1: anywhere, 2: final harbor
static func _teleport(destination: int, n: Node2D) -> void:
	var coord: IntCoord

	match destination:
		0:
			for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
				if FindObject.has_ground_with_sub_tag(i, SubTag.SWAMP):
					coord = i
					break
		1:
			coord = n._ref_RandomNumber.get_dungeon_coord()
		2:
			coord = ConvertCoord.sprite_to_coord(FindObject.get_sprites_with_tag(
					SubTag.FINAL_HARBOR)[0])

	MoveObject.move(FindObject.pc, coord)
	n._end_pc_turn()


static func _add_dinghy(coord: IntCoord, n: Node2D) -> void:
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, n._ref_RandomNumber)
	n._ref_CreateObject.create_building(SubTag.DINGHY, ground_coords[0])


# 0: Rum, 1: Parrot, 2: Accordion
static func _add_item(item: int, n: Node2D) -> void:
	var coord := FindObject.pc_coord
	var sub_tag: String

	match item:
		0:
			sub_tag = SubTag.RUM
		1:
			sub_tag = SubTag.PARROT
		2:
			sub_tag = SubTag.ACCORDION
		_:
			return
	n._ref_CreateObject.create_trap(sub_tag, IntCoord.new(coord.x - 1, coord.y))


static func _add_actor(sub_tag: String, x_offset: int, y_offset: int, n: Node2D) \
		-> void:
	var coord := FindObject.pc_coord
	# var actor: Sprite = n._ref_CreateObject.create(MainTag.ACTOR,
	# 		sub_tag, IntCoord.new(coord.x - 1, coord.y))

	# ObjectState.get_state(actor).face_direction = DirectionTag.LEFT
	n._ref_CreateObject.create(MainTag.ACTOR,
			sub_tag, IntCoord.new(coord.x + x_offset, coord.y + y_offset))
