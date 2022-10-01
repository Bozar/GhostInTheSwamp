extends Node2D
class_name PcFov


var _main_tag_to_sprites := {
	MainTag.GROUND: [],
	MainTag.TRAP: [],
	MainTag.BUILDING: [],
	MainTag.ACTOR: [],
}
var _harbor_sprites: Array


func render(player_win := true) -> void:
	_render()
	if not player_win:
		Palette.set_dark_color(FindObject.pc, MainTag.ACTOR)


func set_reference() -> void:
	_harbor_sprites = FindObject.get_sprites_with_tag(SubTag.HARBOR)


func _render() -> void:
	var coord := FindObject.pc_coord

	_set_render_sprites()
	ShadowCastFov.set_field_of_view(DungeonSize.MAX_X, DungeonSize.MAX_Y,
			coord.x, coord.y, PcData.SIGHT_RANGE,
			self, "_block_line_of_sight", [])

	if TransferData.show_full_map:
		_render_without_fog_of_war()
	else:
		for mtag in _main_tag_to_sprites:
			for i in _main_tag_to_sprites[mtag]:
				# TODO: Consider adding an optional mode using fov with memory.
				# Increase mp progress? Reduce power cost?
				_set_sprite_color(i, mtag, ShadowCastFov, "is_in_sight")
				# _set_sprite_color_with_memory(i, mtag, true, ShadowCastFov,
				# 		"is_in_sight")
	_post_process_fov()


func _render_without_fog_of_war() -> void:
	var coord: IntCoord

	for mtag in _main_tag_to_sprites:
		for i in _main_tag_to_sprites[mtag]:
			coord = ConvertCoord.sprite_to_coord(i)
			i.visible = _sprite_is_visible(mtag, coord, false)
			if mtag == MainTag.GROUND:
				Palette.set_dark_color(i, mtag)


# is_in_sight_func(x: int, y: int) -> bool
func _set_sprite_color(sprite: Sprite, main_tag: String, func_host: Object,
		is_in_sight_func: String) -> void:
	var coord := ConvertCoord.sprite_to_coord(sprite)
	var is_in_sight := funcref(func_host, is_in_sight_func)

	sprite.visible = _sprite_is_visible(main_tag, coord, false)
	if is_in_sight.call_func(coord.x, coord.y):
		Palette.set_default_color(sprite, main_tag)
	else:
		Palette.set_dark_color(sprite, main_tag)


# is_in_sight_func(x: int, y: int) -> bool
func _set_sprite_color_with_memory(sprite: Sprite, main_tag: String,
		ues_memory: bool, func_host: Object, is_in_sight_func: String) -> void:
	var coord := ConvertCoord.sprite_to_coord(sprite)
	var is_in_sight := funcref(func_host, is_in_sight_func)

	sprite.visible = true
	if is_in_sight.call_func(coord.x, coord.y):
		sprite.visible = _sprite_is_visible(main_tag, coord, false)
		if ues_memory:
			_set_sprite_memory(coord, main_tag)
		Palette.set_default_color(sprite, main_tag)
	else:
		# Set visibility based on whether a sprite is covered.
		sprite.visible = _sprite_is_visible(main_tag, coord, ues_memory)
		if ues_memory and _has_sprite_memory(coord, main_tag):
			Palette.set_dark_color(sprite, main_tag)
		else:
			# Set visibility based on whether a sprite is remembered.
			sprite.visible = false


func _sprite_is_visible(main_tag: String, coord: IntCoord, use_memory: bool) \
		-> bool:
	var start_index := ZIndex.get_z_index(main_tag) + 1
	var max_index := ZIndex.LAYERED_MAIN_TAG.size()
	var current_tag: String

	# Check sprites from lower layer to higher ones.
	for i in range(start_index, max_index):
		current_tag = ZIndex.LAYERED_MAIN_TAG[i]
		# There is a sprite on a certian layer.
		if FindObject.has_sprite(current_tag, coord):
			# Show or hide sprites based on memory and stacking layers.
			if use_memory:
				# There is a sprite on a higher layer and we remember it.
				if _has_sprite_memory(coord, current_tag):
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


func _block_line_of_sight(x: int, y: int, _opt: Array) -> bool:
	var coord := IntCoord.new(x, y)
	return FindObject.has_building(coord) or FindObject.has_actor(coord)


func _has_sprite_memory(coord: IntCoord, main_tag: String) -> bool:
	var sprite := FindObject.get_sprite(main_tag, coord)
	return ObjectState.get_state(sprite).fov_memory


func _set_sprite_memory(coord: IntCoord, main_tag: String) -> void:
	var sprite := FindObject.get_sprite(main_tag, coord)

	# Change behavior based on sprites.
	ObjectState.get_state(sprite).fov_memory = (main_tag != MainTag.ACTOR)


func _set_render_sprites() -> void:
	for i in _main_tag_to_sprites:
		_main_tag_to_sprites[i] = FindObject.get_sprites_with_tag(i)


func _post_process_fov() -> void:
	var state: HarborState

	for i in _harbor_sprites:
		state = ObjectState.get_state(i)
		if state.is_active:
			Palette.set_default_color(i, MainTag.BUILDING)
