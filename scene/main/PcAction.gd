extends Node2D
class_name PcAction


const RENDER_SPRITES := {
	MainTag.GROUND: [],
	MainTag.TRAP: [],
	MainTag.BUILDING: [],
	MainTag.ACTOR: [],
}


var _ref_Schedule: Schedule
var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_EndGame: EndGame
var _ref_CreateObject: CreateObject

var _pc: Sprite
var _pc_state: PcState

var _source_position: IntCoord
var _target_position: IntCoord
var _input_direction: String
# Set `_fov_render_range` if we use the default `_fov_render_range()`. Otherwise
# there is no need to set it.
var _fov_render_range := 5
var _render_this: Sprite


func set_reference() -> void:
	_pc = FindObject.pc
	_pc_state = ObjectState.get_state(_pc)


func start_turn() -> void:
	# print("PC starts turn.")
	set_source_position()
	render_fov()


func game_over(win: bool) -> void:
	set_source_position()
	_render_end_game(win)


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
		_ref_Schedule.end_turn()


func use_power() -> void:
	_pc_state.is_using_power = not _pc_state.is_using_power

	# _ref_Schedule.end_turn()


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
	_ref_Schedule.end_turn()


func interact_with_building() -> void:
	pass


func interact_with_trap() -> void:
	pass


func set_source_position() -> void:
	_source_position = FindObject.pc_coord


func set_target_position(direction: String) -> void:
	var shift: Array = InputTag.DIRECTION_TO_COORD[direction]

	_target_position = IntCoord.new(
		_source_position.x + shift[0],
		_source_position.y + shift[1]
	)
	_input_direction = direction


func render_fov() -> void:
	var pc_pos: IntCoord = FindObject.pc_coord
	var this_pos: IntCoord

	_set_render_sprites()
	# if _ref_GameSetting.get_show_full_map():
	# 	_render_without_fog_of_war()
	# 	# _post_process_fov(pc_pos)
	# 	return

	ShadowCastFov.set_field_of_view(
			DungeonSize.MAX_X, DungeonSize.MAX_Y,
			pc_pos.x, pc_pos.y, _fov_render_range,
			self, "_block_line_of_sight", [])

	for mtag in RENDER_SPRITES:
		for i in RENDER_SPRITES[mtag]:
			_render_this = i
			this_pos = ConvertCoord.sprite_to_coord(i)
			_set_sprite_color(this_pos.x, this_pos.y, mtag, ShadowCastFov,
					"is_in_sight")

	_post_process_fov(pc_pos)


func _is_occupied(x: int, y: int) -> bool:
	var coord := IntCoord.new(x, y)
	if not CoordCalculator.is_inside_dungeon(x, y):
		return true
	for i in MainTag.ABOVE_GROUND_OBJECT:
		if FindObject.has_sprite(i, coord):
			return true
	return false


func _render_end_game(win: bool) -> void:
	var pc: Sprite = FindObject.pc

	render_fov()
	if not win:
		Palette.set_dark_color(pc, MainTag.ACTOR)


func _render_without_fog_of_war() -> void:
	var pos: IntCoord

	for mtag in RENDER_SPRITES:
		for i in RENDER_SPRITES[mtag]:
			pos = ConvertCoord.sprite_to_coord(i)
			i.visible = _sprite_is_visible(mtag, pos.x, pos.y, false)
			if mtag == MainTag.GROUND:
				Palette.set_dark_color(i, mtag)


# is_in_sight_func(x: int, y: int) -> bool
func _set_sprite_color(x: int, y: int, main_tag: String, func_host: Object,
		is_in_sight_func: String) -> void:
	var set_this := _render_this
	var is_in_sight := funcref(func_host, is_in_sight_func)

	if set_this == null:
		return
	set_this.visible = _sprite_is_visible(main_tag, x, y, false)
	if is_in_sight.call_func(x, y):
		Palette.set_default_color(set_this, main_tag)
	else:
		Palette.set_dark_color(set_this, main_tag)


# is_in_sight_func(x: int, y: int) -> bool
func _set_sprite_color_with_memory(x: int, y: int, main_tag: String,
		ues_memory: bool, func_host: Object, is_in_sight_func: String) -> void:
	var set_this := _render_this
	var is_in_sight := funcref(func_host, is_in_sight_func)

	if set_this == null:
		return
	set_this.visible = true
	if is_in_sight.call_func(x, y):
		set_this.visible = _sprite_is_visible(main_tag, x, y, false)
		if ues_memory:
			_set_sprite_memory(x, y, main_tag)
		Palette.set_default_color(set_this, main_tag)
	else:
		# Set visibility based on whether a sprite is covered.
		set_this.visible = _sprite_is_visible(main_tag, x, y, ues_memory)
		if ues_memory and _has_sprite_memory(x, y, main_tag):
			Palette.set_dark_color(set_this, main_tag)
		else:
			# Set visibility based on whether a sprite is remembered.
			set_this.visible = false


func _sprite_is_visible(main_tag: String, x: int, y: int, use_memory: bool) \
		-> bool:
	var start_index: int = ZIndex.get_z_index(main_tag) + 1
	var max_index: int = ZIndex.LAYERED_MAIN_TAG.size()
	var current_tag: String
	var coord := IntCoord.new(x, y)

	# Check sprites from lower layer to higher ones.
	for i in range(start_index, max_index):
		current_tag = ZIndex.LAYERED_MAIN_TAG[i]
		# There is a sprite on a certian layer.
		if FindObject.has_sprite(current_tag, coord):
			# Show or hide sprites based on memory and stacking layers.
			if use_memory:
				# There is a sprite on a higher layer and we remember it.
				if _has_sprite_memory(x, y, current_tag):
					return false
				# There is a sprite on a higher layer but we do not remember it.
				# Therefore it is invisible for this rendering.
				continue
			# Show or hide sprites based on actual layers. Since there is a
			# sprite on a higher layer, our sprite in question is invisible.
			return false
	# Either there are no sprites on higher layers, or we do not remember any,
	# our sprite in question is visble.
	return true


func _block_line_of_sight(x: int, y: int, _opt_arg: Array) -> bool:
	var coord := IntCoord.new(x, y)
	return FindObject.has_building(coord) or FindObject.has_actor(coord)


func _has_sprite_memory(x: int, y: int, main_tag: String) -> bool:
	var coord := IntCoord.new(x, y)
	var this_sprite: Sprite = FindObject.get_sprite(main_tag, coord)
	# Temp code. Remove _ref_ObjectState.
	return this_sprite == null
	# return _ref_ObjectState.get_bool(this_sprite)


func _set_sprite_memory(x: int, y: int, main_tag: String) -> void:
	var coord := IntCoord.new(x, y)
	var this_sprite: Sprite = FindObject.get_sprite(main_tag, coord)
	# Temp code. Remove _ref_ObjectState.
	if this_sprite == null:
		pass
	# _ref_ObjectState.set_bool(this_sprite, true)


# Render dungeon objects at the end of the default render_fov().
func _post_process_fov(_pc_coord: IntCoord) -> void:
	pass


func _set_render_sprites() -> void:
	for i in RENDER_SPRITES:
		RENDER_SPRITES[i] = FindObject.get_sprites_by_tag(i)
