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

	if not CoordCalculator.is_inside_dungeon(target_coord):
		return

	if _pc_state.use_power:
		pass
	else:
		if FindObjectHelper.has_swamp(source_coord):
			_move_in_swamp(target_coord)
		# Harbor or land.
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
			_pc_state.add_item(SubTag.RUM)
		InputTag.ADD_PARROT:
			_pc_state.add_item(SubTag.PARROT)
		InputTag.ADD_ACCORDION:
			_pc_state.add_item(SubTag.ACCORDION)
		InputTag.DEV_KEY:
			$DevKey.test()


func _end_turn() -> void:
	var coord := ConvertCoord.sprite_to_coord(_pc)

	# Remove a trap when it is covered by PC or NPC.
	_ref_RemoveObject.remove_trap(coord)
	# Always remove dinghys.
	for i in FindObject.get_sprites_with_tag(SubTag.DINGHY):
		_ref_RemoveObject.remove(i)
	# Remove the ship if PC is not in a harbor.
	if not FindObjectHelper.has_harbor(coord):
		for i in FindObject.get_sprites_with_tag(SubTag.SHIP):
			_ref_RemoveObject.remove(i)
	end_turn = true


# TODO: PC cannot move towards an actor who can see him.
func _move_on_land(move_to: IntCoord) -> void:
	if FindObjectHelper.has_unoccupied_land(move_to):
		pass
	elif _pc_state.has_item(SubTag.ACCORDION) and FindObjectHelper.has_harbor( \
			move_to):
		pass
	else:
		return

	MoveObject.move(_pc, move_to)
	_end_turn()


func _move_in_swamp(move_to: IntCoord) -> void:
	var has_nearby_land := false

	if not FindObjectHelper.has_swamp(move_to):
		return

	# Sail in a pirate ship.
	if _pc_state.has_item(SubTag.ACCORDION):
		if _pc_state.mp > 0:
			_pc_state.sail_duration = 0
		else:
			_pc_state.sail_duration += 1
	# Sail in a dinghy.
	else:
		for i in CoordCalculator.get_neighbor(move_to, 1):
			if FindObjectHelper.has_land_or_harbor(i):
				has_nearby_land = true
				break
		if has_nearby_land:
			_pc_state.sail_duration += 1
		else:
			return

	if _pc_state.has_item(SubTag.RUM):
		if _pc_state.mp > 0:
			_pc_state.mp -= 1

	MoveObject.move(_pc, move_to)
	_end_turn()
