class_name PcSailHelper


const NO_SHIP_FOR_HARBOR := "Cannot create a ship for harbor [%d, %d]."


static func add_ship(_ref_CreateObject: CreateObject) -> void:
	var pc_coord := FindObject.pc_coord
	var land_coord: IntCoord
	var ship_coord: IntCoord
	var has_error := false

	# PC is not in a harbor.
	if not FindObjectHelper.has_harbor(pc_coord):
		return
	# PC enters a harbor from the ship in the last turn.
	elif FindObject.get_sprites_with_tag(SubTag.SHIP).size() > 0:
		return
	# PC enters a harbor from land in the last turn.
	for i in CoordCalculator.get_neighbor(pc_coord, 1):
		if FindObjectHelper.has_land(i):
			land_coord = i
			break

	# There should be one and only one non-swamp grid near a normal harbor. The
	# final harbor can only be entered by a pirate ship.
	if land_coord == null:
		has_error = true
	else:
		ship_coord = CoordCalculator.get_mirror_image(land_coord, pc_coord)
		has_error = (ship_coord == null)
	if has_error:
		push_warning(NO_SHIP_FOR_HARBOR % [pc_coord.x, pc_coord.y])
		return
	_ref_CreateObject.create_building(SubTag.SHIP, ship_coord)


static func add_dinghy(_ref_RandomNumber: RandomNumber, _ref_CreateObject: \
		CreateObject) -> void:
	var state := FindObject.pc_state

	_set_spawn_ghost_timer()
	# print(state.spawn_ghost_timer)
	if state.spawn_ghost_timer < 1:
		state.spawn_ghost_timer = PcData.MAX_GHOST_COUNTDOWN
		state.count_ghost += 1
		_create_dinghy(_ref_RandomNumber, _ref_CreateObject)


static func _set_spawn_ghost_timer() -> void:
	var coord := FindObject.pc_coord
	var state := FindObject.pc_state
	var has_swamp := false
	var has_harbor := false

	if state.has_ghost:
		return
	elif state.count_ghost == state.max_ghost:
		return
	elif not FindObjectHelper.has_land(coord):
		return
	else:
		for i in CoordCalculator.get_neighbor(coord, 1):
			if FindObjectHelper.has_swamp(i):
				has_swamp = true
				break
	# There should be at least one swamp grid for the ghost dinghy to appear.
	if not has_swamp:
		return

	state.spawn_ghost_timer -= 1
	if state.mp <= PcData.LOW_MP:
		state.spawn_ghost_timer -= PcData.CONUT_BONUS_FROM_LOW_MP
	elif state.mp <= PcData.HIGH_MP:
		state.spawn_ghost_timer -= PcData.CONUT_BONUS_FROM_HIGH_MP
	for i in CoordCalculator.get_neighbor(coord, PcData.MIN_RANGE_TO_HARBOR):
		if FindObjectHelper.has_harbor(i):
			has_harbor = true
			break
	if not has_harbor:
		state.spawn_ghost_timer -= PcData.COUNT_BONUS_FROM_HARBOR


static func _create_dinghy(_ref_RandomNumber: RandomNumber, _ref_CreateObject: \
		CreateObject) -> void:
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, _ref_RandomNumber)
	_ref_CreateObject.create_building(SubTag.DINGHY, ground_coords[0])
