extends Node2D
class_name PcAction


const REF_VARS := [
	NodeTag.REMOVE_OBJECT,
	NodeTag.RANDOM_NUMBER,
	NodeTag.CREATE_OBJECT,
]
const REMOVE_SPRITE_PER_TURN := [
	SubTag.DINGHY, SubTag.SHIP,
]

var end_turn := false

var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject

var _pc: Sprite
var _pc_state: PcState


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)

	_pc = FindObject.pc
	_pc_state = ObjectState.get_state(_pc)


func start_turn() -> void:
	end_turn = false


func move(input_tag: String) -> void:
	var source_coord := ConvertCoord.sprite_to_coord(_pc)
	var target_coord := InputTag.get_coord_by_direction(source_coord, input_tag)

	if not CoordCalculator.is_inside_dungeon(target_coord):
		return

	if _pc_state.use_power:
		pass
	else:
		if _has_swamp(source_coord):
			pass
		# Harbor or land.
		else:
			_move_on_land(target_coord)


func toggle_power() -> void:
	var new_sprite := SpriteTypeTag.DEFAULT

	_pc_state.use_power = not _pc_state.use_power
	if _pc_state.use_power:
		new_sprite = SpriteTypeTag.USE_POWER
	SwitchSprite.set_sprite(_pc, new_sprite)


func cancel_power() -> void:
	_pc_state.use_power = false
	SwitchSprite.set_sprite(_pc, SpriteTypeTag.DEFAULT)


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


func _end_turn() -> void:
	# Remove a trap when it is covered by PC or NPC.
	_ref_RemoveObject.remove_trap(ConvertCoord.sprite_to_coord(_pc))
	for tag in REMOVE_SPRITE_PER_TURN:
		for i in FindObject.get_sprites_by_tag(tag):
			_ref_RemoveObject.remove(i)
	end_turn = true


func _has_swamp(coord: IntCoord) -> bool:
	var sprite := FindObject.get_ground(coord)

	if sprite == null:
		return false
	return sprite.is_in_group(SubTag.SWAMP)


func _has_actor(coord: IntCoord) -> bool:
	return FindObject.has_actor(coord)


func _has_building(coord: IntCoord) -> bool:
	return FindObject.has_building(coord)


func _has_harbor(coord: IntCoord) -> bool:
	var sprite := FindObject.get_building(coord)

	if sprite == null:
		return false
	return sprite.is_in_group(SubTag.HARBOR)


func _move_on_land(move_to: IntCoord) -> void:
	var can_move := false

	if _has_swamp(move_to) or _has_actor(move_to):
		pass
	elif _has_building(move_to):
		if _pc_state.has_item(SubTag.ACCORDION) and _has_harbor(move_to):
			can_move = true
	else:
		can_move = true

	if can_move:
		MoveObject.move(_pc, move_to)
		_end_turn()
