class_name SailInSwamp


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
	var state := FindObject.pc_state
	var add_timer: int

	if state.has_ghost:
		return
	elif state.count_ghost == state.max_ghost:
		return
	elif not FindObjectHelper.has_land(FindObject.pc_coord):
		return
	# There should be at least one swamp grid for the ghost dinghy to appear.
	elif not _has_nearby_swamp():
		return

	# Base value.
	add_timer = ref_random.get_int(PcData.MIN_BASE_TIMER, PcData.MAX_BASE_TIMER)
	# MP or NPC bonus.
	if (state.mp < PcData.LOW_MP) or (_is_in_actor_sight()):
		add_timer += PcData.BONUS_TIMER
	state.spawn_ghost_timer += add_timer


static func _create_dinghy(ref_random: RandomNumber, ref_create: CreateObject) \
		-> void:
	var ground_coords := []
	var new_coord: IntCoord

	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	new_coord = ArrayHelper.get_rand_element(ground_coords, ref_random)
	ref_create.create_building(SubTag.DINGHY, new_coord)


static func _has_nearby_swamp() -> bool:
	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_swamp(i):
			return true
	return false


static func _is_in_actor_sight() -> bool:
	for i in DirectionTag.VALID_DIRECTIONS:
		if FindObject.pc_state.is_in_npc_sight(i):
			return true
	return false
