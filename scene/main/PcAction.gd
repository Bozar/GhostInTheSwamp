extends Node2D
class_name PcAction


var end_turn := false

var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject

var _pc: Sprite
var _pc_state: PcState

var _source_position: IntCoord
var _target_position: IntCoord
var _input_direction: String


func set_reference() -> void:
	_pc = FindObject.pc
	_pc_state = ObjectState.get_state(_pc)


func start_turn() -> void:
	end_turn = false
	set_source_position()


func move(input_tag: String) -> void:
	set_source_position()
	set_target_position(input_tag)
	if not is_inside_dungeon():
		return

	if is_npc():
		attack()
	elif is_building():
		interact_with_building()
	elif is_trap():
		interact_with_trap()
	else:
		MoveObject.move(_pc, _target_position)
		end_turn = true


func use_power() -> void:
	_pc_state.use_power = not _pc_state.use_power


func toggle_sight() -> void:
	pass


func press_wizard_key(input_tag: String) -> void:
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


func is_inside_dungeon() -> bool:
	return CoordCalculator.is_inside_dungeon(
			_target_position.x, _target_position.y)


func is_npc() -> bool:
	return FindObject.has_actor(_target_position)


func is_building() -> bool:
	return FindObject.has_building(_target_position)


func is_trap() -> bool:
	return FindObject.has_trap(_target_position)


func attack() -> void:
	_ref_RemoveObject.remove_actor(_target_position)
	end_turn = true


func interact_with_building() -> void:
	pass


func interact_with_trap() -> void:
	pass


func set_source_position() -> void:
	_source_position = FindObject.pc_coord


func set_target_position(direction: String) -> void:
	_target_position = InputTag.get_coord_by_direction(_source_position,
			direction)
	_input_direction = direction


func _is_occupied(x: int, y: int) -> bool:
	var coord := IntCoord.new(x, y)
	if not CoordCalculator.is_inside_dungeon(x, y):
		return true
	for i in MainTag.ABOVE_GROUND_OBJECT:
		if FindObject.has_sprite(i, coord):
			return true
	return false
