extends Node2D
class_name PcAction


const REF_VARS := [
	NodeTag.REMOVE_OBJECT,
	NodeTag.RANDOM_NUMBER,
	NodeTag.CREATE_OBJECT,
]

var end_turn := false

var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject

var _pc: Sprite
var _pc_state: PcState
var _current_sprite_tag: String


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)

	_pc = FindObject.pc
	_pc_state = ObjectState.get_state(_pc)


func start_turn() -> void:
	end_turn = false
	_current_sprite_tag = ObjectState.get_state(_pc).sprite_tag


func move(input_tag: String) -> void:
	var source_coord := ConvertCoord.sprite_to_coord(_pc)
	var target_coord := InputTag.get_coord_by_direction(source_coord, input_tag)
	var direction_tag := InputTag.get_direction_tag(input_tag)
	var power_cost := _pc_state.get_power_cost(direction_tag)

	if not CoordCalculator.is_inside_dungeon(target_coord):
		return

	# Swamp.
	if FindObjectHelper.has_swamp(source_coord):
		if _pc_state.use_power:
			_pc_state.mp -= power_cost
			_use_power_in_swamp(source_coord, target_coord, direction_tag)
		else:
			_move_in_swamp(target_coord)
	# Harbor.
	elif FindObjectHelper.has_harbor(source_coord):
		if _pc_state.use_power:
			_pc_state.mp -= power_cost
			_use_power_in_harbor(source_coord, target_coord, direction_tag)
		else:
			_move_on_land(target_coord)
	# Land.
	else:
		if _pc_state.use_power:
			_pc_state.mp -= power_cost
			pass
		else:
			_move_on_land(target_coord)


func toggle_power() -> void:
	var new_sprite := _current_sprite_tag

	_pc_state.use_power = not _pc_state.use_power
	if _pc_state.use_power:
		new_sprite = SpriteTag.USE_POWER
	SwitchSprite.set_sprite(_pc, new_sprite)


func cancel_power() -> void:
	_pc_state.use_power = false
	SwitchSprite.set_sprite(_pc, _current_sprite_tag)


func toggle_sight() -> void:
	pass


func press_wizard_key(input_tag: String) -> void:
	if _pc_state.use_power:
		cancel_power()
		return

	match input_tag:
		InputTag.ADD_MP:
			_pc_state.mp += 1
		InputTag.FULLY_RESTORE_MP:
			_pc_state.mp = _pc_state.max_mp
		InputTag.ADD_GHOST:
			_pc_state.has_ghost = true
		InputTag.ADD_RUM:
			_pc_state.add_rum()
		InputTag.ADD_PARROT:
			_pc_state.add_parrot()
		InputTag.ADD_ACCORDION:
			_pc_state.add_accordion()
		InputTag.DEV_KEY:
			$DevKey.test()


func _end_turn() -> void:
	# Remove a trap when it is covered by PC or NPC.
	_ref_RemoveObject.remove_trap(ConvertCoord.sprite_to_coord(_pc))
	end_turn = true


# TODO: PC cannot move towards an actor who can see him.
func _move_on_land(move_to: IntCoord) -> void:
	if FindObjectHelper.has_unoccupied_land(move_to):
		pass
	elif _pc_state.has_accordion() and FindObjectHelper.has_harbor(move_to):
		pass
	else:
		return

	MoveObject.move(_pc, move_to)
	_end_turn()


func _move_in_swamp(move_to: IntCoord) -> void:
	var has_accordion := _pc_state.has_accordion()
	var has_nearby_land := false

	# PC can only sail into a swamp grid.
	if not FindObjectHelper.has_swamp(move_to):
		return
	# Pirate ship: PC can enter any swamp grid.
	elif has_accordion:
		pass
	# Dinghy: PC can only enter a swamp that has a land or harbor neighbor.
	else:
		for i in CoordCalculator.get_neighbor(move_to, 1):
			if FindObjectHelper.has_land_or_harbor(i):
				has_nearby_land = true
				break
		if not has_nearby_land:
			return

	if _pc_state.sail_duration < _pc_state.max_sail_duration:
		_pc_state.sail_duration += 1
	elif has_accordion and _pc_state.mp > 0:
		_pc_state.mp -= 1
	MoveObject.move(_pc, move_to)
	_end_turn()


func _use_power_in_swamp(source_coord: IntCoord, target_coord: IntCoord,
		direction_tag: int) -> void:
	if _pc_state.get_power_tag(direction_tag) != PowerTag.LAND:
		return
	# Leave a pirate ship at PC's current position.
	if _pc_state.has_accordion():
		_ref_CreateObject.create_building(SubTag.SHIP, source_coord)
	MoveObject.move(_pc, target_coord)
	_end_turn()


func _use_power_in_harbor(source_coord: IntCoord, target_coord: IntCoord,
		direction_tag: int) -> void:
	match _pc_state.get_power_tag(direction_tag):
		PowerTag.EMBARK:
			# Remove the pirate ship in StartPcTurn._reset_pc_state(). Player
			# cannot lose at this moment.
			MoveObject.move(_pc, target_coord)
		PowerTag.LIGHT:
			_pc_state.has_ghost = false
			HarborHelper.toggle_harbor_with_coord(source_coord, true)
		_:
			return
	_end_turn()
