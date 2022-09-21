extends Node2D
class_name StartPcTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
]

const NO_SHIP_FOR_HARBOR := "Cannot create a ship for harbor [%d, %d]."

var _ref_CreateObject: CreateObject


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
		_add_dinghy()
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

	if not FindObjectHelper.has_harbor(coord):
		return
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


# Reduce countdown timer until a ghost appears.
func _add_dinghy() -> void:
	pass


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
