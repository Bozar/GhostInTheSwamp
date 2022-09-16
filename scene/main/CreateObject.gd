extends Node2D
class_name CreateObject


signal sprite_created(basic_sprite_data)

var _ref_Palette: Palette


func create_and_fetch(main_tag: String, sub_tag: String, coord: IntCoord,
		x_offset := 0, y_offset := 0) -> Sprite:
	var new_sprite: Sprite
	var new_basic: BasicSpriteData
	var sprite_color: String
	var z_index: int

	new_sprite = PackedSceneData.get_packed_scene(sub_tag).instance()
	new_basic = BasicSpriteData.new(new_sprite, main_tag, sub_tag, coord)
	sprite_color = _ref_Palette.get_default_color(main_tag)
	z_index = ZIndex.get_z_index(main_tag)

	new_sprite.position = ConvertCoord.coord_to_vector(coord, x_offset,
			y_offset)
	new_sprite.add_to_group(main_tag)
	new_sprite.add_to_group(sub_tag)
	new_sprite.z_index = z_index
	new_sprite.modulate = sprite_color

	add_child(new_sprite)
	ObjectState.add_state(new_basic)
	emit_signal(SignalTag.SPRITE_CREATED, new_basic)

	return new_sprite


func create(main_tag: String, sub_tag: String, coord: IntCoord, x_offset := 0,
		y_offset := 0) -> void:
	create_and_fetch(main_tag, sub_tag, coord, x_offset, y_offset)


func create_ground(sub_tag: String, coord: IntCoord) -> void:
	create(MainTag.GROUND, sub_tag, coord)


func create_trap(sub_tag: String, coord: IntCoord) -> void:
	create(MainTag.TRAP, sub_tag, coord)


func create_building(sub_tag: String, coord: IntCoord) -> void:
	create(MainTag.BUILDING, sub_tag, coord)


func create_actor(sub_tag: String, coord: IntCoord) -> void:
	create(MainTag.ACTOR, sub_tag, coord)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == ScreenTag.MAIN)
