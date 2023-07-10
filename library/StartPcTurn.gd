extends Node2D
class_name StartPcTurn


static func renew_world(ref_remove: RemoveObject) -> void:
	_remove_sprites(ref_remove)
	_reset_state()


static func set_pc_state(ref_create: CreateObject) -> void:
	var pc_coord := FindObject.pc_coord
	var pc_state := FindObject.pc_state

	# Swamp.
	if FindObjectHelper.has_swamp(pc_coord):
		_set_movement_in_swamp()
		# PowerTag.LAND.
		_set_swamp_power(pc_coord, pc_state)
	# Harbor.
	elif FindObjectHelper.has_harbor(pc_coord):
		SailInSwamp.add_ship(ref_create)
		set_movement_outside_swamp()
		# PowerTag.LIGHT.
		_set_harbor_power(pc_coord, pc_state)
	# Land powers are complicated and tightly coupled with NPC sight. Therefore
	# they will be set in Progress later.


static func set_movement_outside_swamp() -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		FindObject.pc_state.set_direction_to_movement(i,
				_try_move_outside_swamp(i))


static func _reset_state() -> void:
	var state := FindObject.pc_state

	# All states are reset whether or not the next actor is PC.
	PcSprite.set_default_sprite()
	# Reset sail duration if PC is on land or harbor.
	if not FindObjectHelper.has_swamp(FindObject.pc_coord):
		state.sail_duration = 0
		state.use_pirate_ship = false
	# Clear sight and power data.
	state.reset_direction_to_sight_power()
	state.use_power = false


static func _remove_sprites(ref_remove: RemoveObject) -> void:
	# Always remove dinghys.
	for i in FindObject.get_sprites_with_tag(SubTag.DINGHY):
		ref_remove.remove(i)
	# Remove pirate ships if PC is not in a harbor.
	if not FindObjectHelper.has_harbor(FindObject.pc_coord):
		for i in FindObject.get_sprites_with_tag(SubTag.SHIP):
			ref_remove.remove(i)


static func _set_swamp_power(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord

	for i in DirectionTag.VALID_DIRECTIONS:
		target = CoordCalculator.get_coord_by_direction(coord, i)
		if FindObjectHelper.has_unoccupied_land(target):
			state.set_power_tag(i, PowerTag.LAND)
			if state.mp > PcData.HIGH_MP:
				state.set_power_cost(i, PcData.COST_LAND_GROUND)


static func _set_harbor_power(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord

	if (not state.has_ghost) or HarborHelper.is_active(coord):
		return
	for i in DirectionTag.VALID_DIRECTIONS:
		target = CoordCalculator.get_coord_by_direction(coord, i)
		if FindObjectHelper.has_land(target):
			state.set_power_tag(i, PowerTag.LIGHT)
			break


static func _set_movement_in_swamp() -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		FindObject.pc_state.set_direction_to_movement(i, _try_move_in_swamp(i))


static func _try_move_outside_swamp(direction_tag: int) -> bool:
	var move_from := FindObject.pc_coord
	var move_to := CoordCalculator.get_coord_by_direction(move_from,
			direction_tag)
	var pc_state := FindObject.pc_state

	# Harbor or land.
	if not CoordCalculator.is_inside_dungeon(move_to):
		return false
	# Harbor or land.
	elif FindObjectHelper.has_unoccupied_land(move_to):
		if pc_state.is_in_npc_sight(direction_tag):
			return false
		return true
	# Land.
	elif HarborHelper.can_enter_by_coord(move_to):
		return true
	# Harbor.
	elif FindObjectHelper.has_ship(move_to):
		return true
	# Land.
	elif FindObjectHelper.has_dinghy(move_to):
		return true
	return false


static func _try_move_in_swamp(direction_tag: int) -> bool:
	var move_from := FindObject.pc_coord
	var move_to := CoordCalculator.get_coord_by_direction(move_from,
			direction_tag)
	var pc_state := FindObject.pc_state

	# PC can enter a harbor from swamp.
	if HarborHelper.can_enter_by_coord(move_to):
		return true
	# PC can only sail into a swamp grid.
	elif not FindObjectHelper.has_swamp(move_to):
		return false
	# Pirate ship.
	elif pc_state.use_pirate_ship:
		return true
	# Dinghy: PC can only enter a swamp that has a land or harbor neighbor.
	for i in CoordCalculator.get_neighbor(move_to, 1):
		if FindObjectHelper.has_land_or_harbor(i):
			return true
	return false
