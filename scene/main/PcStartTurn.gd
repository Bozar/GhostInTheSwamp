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
	var pc_coord := FindObject.pc_coord
	var pc_state := FindObject.pc_state

	_remove_sprites(pc_coord)
	reset_state()

	# Set PC sprite, add building, set actor fov (PC state), set PC power.
	if FindObjectHelper.has_swamp(pc_coord):
		# PowerTag.LAND.
		_set_swamp_power(pc_coord, pc_state)
	elif FindObjectHelper.has_harbor(pc_coord):
		PcSail.add_ship(_ref_CreateObject)
		# PowerTag.[EMBARK|LIGHT].
		_set_harbor_power(pc_coord, pc_state)
	# Land
	else:
		PcSail.add_dinghy(_ref_RandomNumber, _ref_CreateObject)
		# Land powers are complicated and tightly coupled with NPC sight.
		# Therefore they will be set in Progress later.

	# PC with lower MP has a higher chance to summon a ghost. So add MP at last.
	_set_mp_progress(pc_coord, pc_state)


func reset_state() -> void:
	var state := FindObject.pc_state

	# All states are reset whether or not the next actor is PC.
	PcSprite.set_default_sprite()
	# Reset sail duration if PC is on land or harbor.
	if not FindObjectHelper.has_swamp(FindObject.pc_coord):
		state.sail_duration = 0
	# Clear sight and power data.
	state.reset_direction_to_sight_power()
	state.use_power = false


func _set_mp_progress(pc_coord: IntCoord, pc_state: PcState) -> void:
	var count_harbor := 0

	# Count active harbors.
	for i in FindObjectHelper.get_harbors():
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


func _set_swamp_power(coord: IntCoord, state: PcState) -> void:
	var target: IntCoord

	for i in DirectionTag.VALID_DIRECTIONS:
		target = DirectionTag.get_coord_by_direction(coord, i)
		if state.has_accordion() and FindObjectHelper.has_harbor(target):
			state.set_power_tag(i, PowerTag.LAND)
		elif FindObjectHelper.has_unoccupied_land(target):
			state.set_power_tag(i, PowerTag.LAND)
			if state.mp > PcData.LOW_MP:
				state.set_power_cost(i, PcData.COST_LAND_GROUND)


func _set_harbor_power(coord: IntCoord, state: PcState) -> void:
	var harbor_is_not_active := not HarborHelper.is_active(coord)
	var target: IntCoord

	for i in DirectionTag.VALID_DIRECTIONS:
		target = DirectionTag.get_coord_by_direction(coord, i)
		# Embark a pirate ship.
		if FindObjectHelper.has_ship(target):
			state.set_power_tag(i, PowerTag.EMBARK)
		# Light a harbor. Note that the final harbor is always active.
		elif state.has_ghost and harbor_is_not_active and FindObjectHelper. \
				has_land(target):
			state.set_power_tag(i, PowerTag.LIGHT)


func _remove_sprites(coord: IntCoord) -> void:
	# Always remove dinghys.
	for i in FindObject.get_sprites_with_tag(SubTag.DINGHY):
		_ref_RemoveObject.remove(i)
	# Remove the ship if PC is not in a harbor.
	if not FindObjectHelper.has_harbor(coord):
		for i in FindObject.get_sprites_with_tag(SubTag.SHIP):
			_ref_RemoveObject.remove(i)
