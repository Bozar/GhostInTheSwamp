extends Node2D
class_name StartPcTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
	NodeTag.RANDOM_NUMBER,
]

const NO_SHIP_FOR_HARBOR := "Cannot create a ship for harbor [%d, %d]."

var _ref_CreateObject: CreateObject
var _ref_RandomNumber: RandomNumber

var _ghost_countdown := PcData.MAX_GHOST_COUNTDOWN


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	var pc := FindObject.pc
	var pc_coord := ConvertCoord.sprite_to_coord(pc)
	var pc_state := ObjectState.get_state(pc)

	# Set PC sprite, add building, set actor fov (PC state), set PC power.
	if FindObjectHelper.has_swamp(pc_coord):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.SWAMP)
		_set_power_in_swamp()
	elif FindObjectHelper.has_harbor(pc_coord):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.HARBOR)
		_add_ship(pc_coord)
		_set_power_on_harbor()
	# Land
	else:
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.LAND)
		_add_dinghy(pc_coord, pc_state)
		_set_actor_fov()
		_set_power_on_land()

	# PC with lower MP has a higher chance to summon a ghost. So add MP at last.
	_set_mp_progress(pc_coord, pc_state)


func _set_mp_progress(pc_coord: IntCoord, pc_state: PcState) -> void:
	var count_harbor := 0

	# Count active harbors.
	for i in FindObjectHelper.get_harbor():
		if (ObjectState.get_state(i) as BuildingState).is_active:
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
			if (ObjectState.get_state(building) as BuildingState).is_active:
				new_sprite = SpriteTag.ACTIVE_HARBOR
			else:
				new_sprite = SpriteTag.DEFAULT_HARBOR
		SubTag.SWAMP:
			if state.has_item(SubTag.ACCORDION):
				new_sprite = SpriteTag.SHIP
			else:
				new_sprite = SpriteTag.DINGHY
		_:
			pass
	SwitchSprite.set_sprite(pc, new_sprite)


func _set_power_in_swamp() -> void:
	pass


func _set_power_on_harbor() -> void:
	pass


func _set_power_on_land() -> void:
	pass


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
