extends Node2D
class_name StartPcTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
	NodeTag.RANDOM_NUMBER,
	NodeTag.REMOVE_OBJECT,
]

const NO_SHIP_FOR_HARBOR := "Cannot create a ship for harbor [%d, %d]."

var _ref_CreateObject: CreateObject
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject

var _ghost_countdown := PcData.MAX_GHOST_COUNTDOWN


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	var pc := FindObject.pc
	var pc_coord := ConvertCoord.sprite_to_coord(pc)
	var pc_state := ObjectState.get_state(pc)

	_reset_pc_state(pc_coord, pc_state)

	# Set PC sprite, add building, set actor fov (PC state), set PC power.
	if FindObjectHelper.has_swamp(pc_coord):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.SWAMP)
		# PowerTag.LAND.
		_set_power_in_swamp(pc_coord, pc_state)
	elif FindObjectHelper.has_harbor(pc_coord):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.HARBOR)
		_add_ship(pc_coord)
		# PowerTag.[EMBARK|LIGHT].
		_set_power_on_harbor(pc_coord, pc_state)
	# Land
	else:
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.LAND)
		_add_dinghy(pc_coord, pc_state)
		_set_actor_fov()
		# PowerTag.[EMBARK|LIGHT|Pick|Spook|Swap].
		_set_power_on_land(pc_coord, pc_state)

	# PC with lower MP has a higher chance to summon a ghost. So add MP at last.
	_set_mp_progress(pc_coord, pc_state)


func _set_mp_progress(pc_coord: IntCoord, pc_state: PcState) -> void:
	var count_harbor := 0

	# Count active harbors.
	for i in FindObjectHelper.get_harbor():
		if (ObjectState.get_state(i) as HarborState).is_active:
			count_harbor += 1
	# If PC sails in a pirate ship and is far away from land and harbor, reduce
	# the number of active harbors by 1. Otherwise leave it unchanged.
	count_harbor -= 1
	for i in CoordCalculator.get_neighbor(pc_coord, 1, true):
		if FindObjectHelper.has_land_or_harbor(i):
			count_harbor += 1
			break
	# Increase MP progress based on the number of active harbors.
	pc_state.mp_progress += PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)


func _add_ship(coord: IntCoord) -> void:
	var non_swamp_coord: IntCoord
	var ship_coord: IntCoord
	var has_error := false

	# PC is not in a harbor.
	if not FindObjectHelper.has_harbor(coord):
		return
	# PC enters a harbor from the ship in the last turn.
	elif FindObject.get_sprites_with_tag(SubTag.SHIP).size() > 0:
		return
	# PC enters a harbor from land in the last turn.
	for i in CoordCalculator.get_neighbor(coord, 1):
		if not FindObjectHelper.has_swamp(i):
			non_swamp_coord = i
			break

	# There should be one and only one non-swamp grid near a harbor.
	if non_swamp_coord == null:
		has_error = true
	else:
		ship_coord = CoordCalculator.get_mirror_image(non_swamp_coord, coord)
		has_error = (ship_coord == null)
	if has_error:
		push_warning(NO_SHIP_FOR_HARBOR % [coord.x, coord.y])
		return
	_ref_CreateObject.create_building(SubTag.SHIP, ship_coord)


func _add_dinghy(coord: IntCoord, state: PcState) -> void:
	_set_ghost_countdown(coord, state)
	# print(_ghost_countdown)
	if _ghost_countdown < 1:
		_ghost_countdown = PcData.MAX_GHOST_COUNTDOWN
		state.count_ghost += 1
		_create_dinghy(coord)


func _set_actor_fov() -> void:
	pass


func _set_pc_sprite(pc: Sprite, coord: IntCoord, state: PcState,
		sub_tag: String) -> void:
	var new_sprite := SpriteTag.DEFAULT
	var building: Sprite

	match sub_tag:
		SubTag.HARBOR:
			building = FindObjectHelper.get_harbor_with_coord(coord)
			if (ObjectState.get_state(building) as HarborState).is_active:
				new_sprite = SpriteTag.ACTIVE_HARBOR
			else:
				new_sprite = SpriteTag.DEFAULT_HARBOR
		SubTag.SWAMP:
			if state.has_accordion():
				new_sprite = SpriteTag.SHIP
			else:
				new_sprite = SpriteTag.DINGHY
		_:
			pass
	SwitchSprite.set_sprite(pc, new_sprite)


func _set_power_in_swamp(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord
	var power_cost: int

	for i in DirectionTag.VALID_DIRECTIONS:
		target = DirectionTag.get_coord_by_direction(coord, i)
		if state.has_accordion() and FindObjectHelper.has_harbor(target):
			state.set_power_tag(i, PowerTag.LAND)
			state.set_power_cost(i, PcData.COST_LAND_HARBOR)
		elif FindObjectHelper.has_land(target):
			if state.mp > PcData.LOW_MP:
				power_cost = PcData.COST_LAND_GROUND
			else:
				power_cost = PcData.COST_LAND_HARBOR
			state.set_power_tag(i, PowerTag.LAND)
			state.set_power_cost(i, power_cost)


func _set_power_on_harbor(coord: IntCoord, state: PcState) -> void:
	var harbor_is_not_active := not HarborHelper.is_active(coord)
	var target: IntCoord

	for i in DirectionTag.VALID_DIRECTIONS:
		target = DirectionTag.get_coord_by_direction(coord, i)
		# Embark a pirate ship.
		if FindObjectHelper.has_ship(target):
			state.set_power_tag(i, PowerTag.EMBARK)
			state.set_power_cost(i, PcData.COST_EMBARK)
		# Light a harbor.
		elif state.has_ghost and harbor_is_not_active and FindObjectHelper. \
				has_land(target):
			state.set_power_tag(i, PowerTag.LIGHT)
			state.set_power_cost(i, PcData.COST_LIGHT)


func _set_power_on_land(coord: IntCoord, state: PcState) -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		if _block_by_neighbor(coord, state, i):
			continue
		# TODO: Cast a ray.


func _set_ghost_countdown(coord: IntCoord, state: PcState) -> void:
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

	_ghost_countdown -= 1
	if state.mp <= PcData.LOW_MP:
		_ghost_countdown -= PcData.CONUT_BONUS_FROM_LOW_MP
	elif state.mp <= PcData.HIGH_MP:
		_ghost_countdown -= PcData.CONUT_BONUS_FROM_HIGH_MP
	for i in CoordCalculator.get_neighbor(coord, PcData.MIN_RANGE_TO_HARBOR):
		if FindObjectHelper.has_harbor(i):
			has_harbor = true
			break
	if not has_harbor:
		_ghost_countdown -= PcData.COUNT_BONUS_FROM_HARBOR


func _create_dinghy(coord: IntCoord) -> void:
	var ground_coords := []

	for i in CoordCalculator.get_neighbor(coord, 1):
		if FindObjectHelper.has_swamp(i):
			ground_coords.push_back(i)
	if ground_coords.size() < 1:
		return
	ArrayHelper.shuffle(ground_coords, _ref_RandomNumber)
	_ref_CreateObject.create_building(SubTag.DINGHY, ground_coords[0])


func _reset_pc_state(coord: IntCoord, state: PcState) -> void:
	# Always remove dinghys.
	for i in FindObject.get_sprites_with_tag(SubTag.DINGHY):
		_ref_RemoveObject.remove(i)
	# Remove the ship if PC is not in a harbor.
	if not FindObjectHelper.has_harbor(coord):
		for i in FindObject.get_sprites_with_tag(SubTag.SHIP):
			_ref_RemoveObject.remove(i)
	# Reset sail duration if PC is on land or harbor.
	if not FindObjectHelper.has_swamp(coord):
		state.reset_sail_duration()
	# Clear sight and power data.
	state.reset_direction_to_sight_power()
	state.use_power = false


func _block_by_neighbor(coord: IntCoord, state: PcState, direction: int) -> bool:
	var target := DirectionTag.get_coord_by_direction(coord, direction)
	var harbor_is_not_active: bool

	if FindObject.has_actor(target):
		# TODO: Spook an actor.
		return true
	elif FindObject.has_building(target):
		if FindObjectHelper.has_dinghy(target):
			state.set_power_tag(direction, PowerTag.EMBARK)
			state.set_power_cost(direction, PcData.COST_EMBARK)
		elif FindObjectHelper.has_harbor(target):
			harbor_is_not_active = not HarborHelper.is_active(target)
			if state.has_ghost and harbor_is_not_active:
				state.set_power_tag(direction, PowerTag.LIGHT)
				state.set_power_cost(direction, PcData.COST_LIGHT)
		return true
	elif FindObject.has_trap(target):
		state.set_power_tag(direction, PowerTag.PICK)
		state.set_power_cost(direction, PcData.COST_PICK)
		return true
	return false
