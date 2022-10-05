extends Node2D
class_name PcStartTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
	NodeTag.RANDOM_NUMBER,
	NodeTag.REMOVE_OBJECT,
]

var _ref_CreateObject: CreateObject
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	_remove_sprites()
	_reset_state()


func set_pc_state() -> void:
	var pc_coord := FindObject.pc_coord
	var pc_state := FindObject.pc_state

	# Set PC sprite, add building, set actor fov (PC state), set PC power.
	if FindObjectHelper.has_swamp(pc_coord):
		_set_movement_in_swamp()
		# PowerTag.LAND.
		_set_swamp_power(pc_coord, pc_state)
	elif FindObjectHelper.has_harbor(pc_coord):
		PcSail.add_ship(_ref_CreateObject)
		set_movement_outside_swamp()
		# PowerTag.LIGHT.
		_set_harbor_power(pc_coord, pc_state)
	# Land
	else:
		PcSail.add_dinghy(_ref_RandomNumber, _ref_CreateObject)
		# Land powers are complicated and tightly coupled with NPC sight.
		# Therefore they will be set in Progress later.

	# PC with lower MP has a higher chance to summon a ghost. So add MP at last.
	_set_mp_progress(pc_coord, pc_state)


func set_movement_outside_swamp() -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		FindObject.pc_state.set_direction_to_movement(i,
				_try_move_outside_swamp(i))


func _reset_state() -> void:
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


func _remove_sprites() -> void:
	var coord := FindObject.pc_coord

	# Always remove dinghys.
	for i in FindObject.get_sprites_with_tag(SubTag.DINGHY):
		_ref_RemoveObject.remove(i)
	# Remove pirate ships if PC is not in a harbor.
	if not FindObjectHelper.has_harbor(coord):
		for i in FindObject.get_sprites_with_tag(SubTag.SHIP):
			_ref_RemoveObject.remove(i)


func _set_mp_progress(pc_coord: IntCoord, pc_state: PcState) -> void:
	var count_harbor := 0
	var add_progress: int
	var harbor_reduction: int
	var sail_reduction: int
	var collide_reduction := 0

	# Count active harbors.
	for i in FindObjectHelper.get_harbors():
		if (ObjectState.get_state(i) as HarborState).is_active:
			count_harbor += 1
	count_harbor = min(count_harbor, PcData.MAX_VALID_HARBOR) as int
	# Increase MP progress based on the number of active harbors.
	add_progress = PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)

	# MP restores slower if PC is close to an active harbor.
	for i in CoordCalculator.get_neighbor(pc_coord, PcData.MIN_RANGE_TO_HARBOR):
		if HarborHelper.is_active(i):
			harbor_reduction = PcData.HARBOR_TO_MP_PROGRESS[2]
			break
	# MP restores slower if PC is away from land.
	if not FindObjectHelper.has_land(pc_coord):
		if FindObjectHelper.has_nearby_land_or_harbor(pc_coord):
			sail_reduction = PcData.HARBOR_TO_MP_PROGRESS[2]
		else:
			sail_reduction = PcData.HARBOR_TO_MP_PROGRESS[3]
	# MP restores slower due to actors collision.
	while pc_state.actor_collision > 0:
		pc_state.actor_collision -= 1
		collide_reduction += _ref_RandomNumber.get_int(
				PcData.MIN_COLLIDE_REDUCTION, PcData.MAX_COLLIDE_REDUCTION)

	add_progress -= collide_reduction
	add_progress -= max(harbor_reduction, sail_reduction) as int
	add_progress = max(0, add_progress) as int
	pc_state.mp_progress += add_progress


func _set_swamp_power(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord

	for i in DirectionTag.VALID_DIRECTIONS:
		target = CoordCalculator.get_coord_by_direction(coord, i)
		if FindObjectHelper.has_unoccupied_land(target):
			state.set_power_tag(i, PowerTag.LAND)
			if state.mp > PcData.LOW_MP:
				state.set_power_cost(i, PcData.COST_LAND_GROUND)


func _set_harbor_power(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord

	if (not state.has_ghost) or HarborHelper.is_active(coord):
		return
	for i in DirectionTag.VALID_DIRECTIONS:
		target = CoordCalculator.get_coord_by_direction(coord, i)
		if FindObjectHelper.has_land(target):
			state.set_power_tag(i, PowerTag.LIGHT)
			break


func _set_movement_in_swamp() -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		FindObject.pc_state.set_direction_to_movement(i, _try_move_in_swamp(i))


func _try_move_outside_swamp(direction_tag: int) -> bool:
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
	elif _can_enter_harbor(pc_state, move_to):
		return true
	# Harbor.
	elif FindObjectHelper.has_ship(move_to):
		return true
	# Land.
	elif FindObjectHelper.has_dinghy(move_to):
		return true
	return false


func _try_move_in_swamp(direction_tag: int) -> bool:
	var move_from := FindObject.pc_coord
	var move_to := CoordCalculator.get_coord_by_direction(move_from,
			direction_tag)
	var pc_state := FindObject.pc_state

	# PC can enter a harbor from swamp.
	if _can_enter_harbor(pc_state, move_to):
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


func _can_enter_harbor(pc_state: PcState, move_to: IntCoord) -> bool:
	return pc_state.has_accordion() and FindObjectHelper.has_harbor(move_to)
