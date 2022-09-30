extends Node2D
class_name PcAction


const REF_VARS := [
	NodeTag.REMOVE_OBJECT,
	NodeTag.RANDOM_NUMBER,
	NodeTag.CREATE_OBJECT,
]

var end_turn := false setget _set_none, get_end_turn
var use_power := false setget _set_none, get_use_power

var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject

var _drop_score := {
	SubTag.RUM: 0,
	SubTag.PARROT: 0,
	SubTag.ACCORDION: 0,
}

var _current_sprite_tag: String


func get_end_turn() -> bool:
	return end_turn


func get_use_power() -> bool:
	var state := FindObject.pc_state
	return (state != null) and state.use_power


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func start_turn() -> void:
	end_turn = false
	_current_sprite_tag = FindObject.pc_state.sprite_tag


func move(input_tag: String) -> void:
	var source_coord := FindObject.pc_coord
	# 1 grid away from PC.
	var target_coord := InputTag.get_coord_by_direction(source_coord, input_tag)
	var direction := InputTag.get_direction_tag(input_tag)
	var pc_state := FindObject.pc_state
	var power_cost := pc_state.get_power_cost(direction)
	var has_power := pc_state.get_power_tag(direction) != PowerTag.NO_POWER

	if not CoordCalculator.is_inside_dungeon(target_coord):
		return

	# Swamp.
	if FindObjectHelper.has_swamp(source_coord):
		if pc_state.use_power:
			if has_power:
				pc_state.mp -= power_cost
				_use_power_in_swamp(source_coord, target_coord, direction)
		elif pc_state.get_direction_to_movement(direction):
			_move_in_swamp(target_coord)
	# Harbor.
	elif FindObjectHelper.has_harbor(source_coord):
		if pc_state.use_power:
			if has_power:
				pc_state.mp -= power_cost
				_use_power_in_harbor(source_coord, target_coord, direction)
		elif pc_state.get_direction_to_movement(direction):
			_move_on_land(target_coord)
	# Land.
	else:
		if pc_state.use_power:
			if has_power:
				pc_state.mp -= power_cost
				_use_power_on_land(direction)
		elif pc_state.get_direction_to_movement(direction):
			_move_on_land(target_coord)


func press_wizard_key(input_tag: String) -> void:
	var pc_state := FindObject.pc_state

	if pc_state.use_power:
		PcSprite.exit_power_mode()
		return

	match input_tag:
		InputTag.ADD_MP:
			pc_state.mp += 1
		InputTag.FULLY_RESTORE_MP:
			pc_state.mp = pc_state.max_mp
		InputTag.ADD_GHOST:
			pc_state.has_ghost = true
		InputTag.ADD_RUM:
			pc_state.add_rum()
		InputTag.ADD_PARROT:
			pc_state.add_parrot()
		InputTag.ADD_ACCORDION:
			pc_state.add_accordion()
		InputTag.DEV_KEY:
			DevKey.test(self)


func _end_turn() -> void:
	# Remove a trap when it is covered by PC or NPC.
	_ref_RemoveObject.remove_trap(FindObject.pc_coord)
	end_turn = true


func _move_on_land(move_to: IntCoord) -> void:
	MoveObject.move(FindObject.pc, move_to)
	_end_turn()


func _move_in_swamp(move_to: IntCoord) -> void:
	var pc_state := FindObject.pc_state

	if pc_state.sail_duration < pc_state.max_sail_duration:
		pc_state.sail_duration += 1
	elif pc_state.use_pirate_ship and (pc_state.mp > 0):
		pc_state.mp -= 1
	MoveObject.move(FindObject.pc, move_to)
	_end_turn()


func _use_power_in_swamp(source_coord: IntCoord, target_coord: IntCoord,
		direction_tag: int) -> void:
	var pc_state := FindObject.pc_state

	if pc_state.get_power_tag(direction_tag) != PowerTag.LAND:
		return
	# Leave a pirate ship at PC's current position. It will be removed in
	# PcStartTurn._remove_sprites().
	if pc_state.use_pirate_ship:
		_ref_CreateObject.create_building(SubTag.SHIP, source_coord)
	MoveObject.move(FindObject.pc, target_coord)
	_end_turn()


func _use_power_in_harbor(source_coord: IntCoord, target_coord: IntCoord,
		direction_tag: int) -> void:
	var pc_state := FindObject.pc_state

	match pc_state.get_power_tag(direction_tag):
		PowerTag.EMBARK:
			# Remove the pirate ship in PcStartTurn._resetpc_state(). Player
			# cannot lose at this moment.
			pc_state.use_pirate_ship = true
			MoveObject.move(FindObject.pc, target_coord)
		PowerTag.LIGHT:
			pc_state.has_ghost = false
			HarborHelper.toggle_harbor_with_coord(source_coord, true)
		_:
			return
	_end_turn()


func _use_power_on_land(direction_tag: int) -> void:
	var pc := FindObject.pc
	var pc_state := FindObject.pc_state
	var target_sprite := pc_state.get_target_sprite(direction_tag)
	var target_state := ObjectState.get_state(target_sprite)
	var target_coord := target_state.coord
	var sub_tag := target_state.sub_tag

	match pc_state.get_power_tag(direction_tag):
		PowerTag.EMBARK:
			if sub_tag == SubTag.DINGHY:
				pc_state.has_ghost = true
				pc_state.use_pirate_ship = false
			MoveObject.move(pc, target_coord)
		PowerTag.LIGHT:
			pc_state.has_ghost = false
			HarborHelper.toggle_harbor_with_coord(target_coord, true)
		PowerTag.TELEPORT:
			pc_state.has_ghost = false
			MoveObject.move(pc, target_coord)
		PowerTag.PICK:
			pc_state.add_item(sub_tag)
			_ref_RemoveObject.remove(target_sprite)
		PowerTag.SPOOK:
			_ref_RemoveObject.remove(target_sprite)
			MoveObject.move(pc, target_coord)
			_drop_item(sub_tag)
		PowerTag.SWAP:
			pc_state.has_ghost = false
			MoveObject.swap(pc, target_sprite)
			(target_state as ActorState).reset_walk_path()
		_:
			return
	_end_turn()


func _set_none(__) -> void:
	return


# func _drop_item(actor_sub_tag: String, power_direction: int) -> void:
func _drop_item(actor_sub_tag: String) -> void:
	var trap_sub_tag := ActorDropItem.get_sub_tag(actor_sub_tag, _drop_score,
			_ref_RandomNumber)
	# var drop_coord: IntCoord

	if trap_sub_tag == SubTag.INVALID:
		return
	FindObject.pc_state.add_item(trap_sub_tag)

	# Auto pick up an item. Increase Spook cost by 1 when more than
	# PcData.ITEM_TO_MAX_GHOST ghosts have appeared. Do not remove code about
	# detecting and picking up items just in case I need them later.
	# --------------------------------------------------------------------------
	# drop_coord = DirectionTag.get_coord_by_direction(FindObject.pc_coord,
	# 		DirectionTag.get_opposite_direction(power_direction))
	# _ref_CreateObject.create_trap(trap_sub_tag, drop_coord)
