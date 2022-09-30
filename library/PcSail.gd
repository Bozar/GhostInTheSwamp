class_name PcSail


const NO_SHIP_FOR_HARBOR := "Cannot create a ship for harbor [%d, %d]."


static func add_ship(ref_create: CreateObject) -> void:
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
	# final harbor can be entered by a pirate ship or teleportation.
	if FindObjectHelper.has_final_harbor(pc_coord):
		return
	elif land_coord == null:
		has_error = true
	else:
		ship_coord = CoordCalculator.get_mirror_image(land_coord, pc_coord)
		has_error = (ship_coord == null)
	if has_error:
		push_warning(NO_SHIP_FOR_HARBOR % [pc_coord.x, pc_coord.y])
		return
	ref_create.create_building(SubTag.SHIP, ship_coord)


static func add_dinghy(ref_random: RandomNumber, ref_create: CreateObject) \
		-> void:
	var state := FindObject.pc_state

	_set_spawn_ghost_timer(ref_random)
	if state.spawn_ghost_timer >= PcData.MAX_GHOST_TIMER:
		state.spawn_ghost_timer = 0
		state.count_ghost += 1
		_create_dinghy(ref_random, ref_create)


static func _set_spawn_ghost_timer(ref_random: RandomNumber) -> void:
	var coord := FindObject.pc_coord
	var state := FindObject.pc_state
	var has_swamp := false
	var has_harbor := false
	var add_timer := 0

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

	# Base value.
	add_timer += PcData.TIMER_ADD_PER_TURN
	# MP bonus.
	if state.mp <= PcData.LOW_MP:
		add_timer += PcData.TIMER_BONUS_FROM_LOW_MP
	elif state.mp <= PcData.HIGH_MP:
		add_timer += PcData.TIMER_BONUS_FROM_HIGH_MP
	# Harbor bonus.
	for i in CoordCalculator.get_neighbor(coord, PcData.MIN_RANGE_TO_HARBOR):
		if FindObjectHelper.has_harbor(i):
			has_harbor = true
			break
	if not has_harbor:
		add_timer += PcData.TIMER_BONUS_FROM_HARBOR
	# Random offset.
	add_timer += ref_random.get_int(0, PcData.TIMER_OFFSET)

	state.spawn_ghost_timer += add_timer


static func _create_dinghy(ref_random: RandomNumber, ref_create: CreateObject) \
		-> void:
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, ref_random)
	ref_create.create_building(SubTag.DINGHY, ground_coords[0])
