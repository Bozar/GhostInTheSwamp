extends Node2D
class_name CreateObject


signal sprite_created(new_sprite)


func create(main_tag: String, sub_tag: String, coord: IntCoord, more_tags := [],
		x_offset: int = 0, y_offset: int = 0) -> Sprite:
	var new_sprite: Sprite
	var sprite_color: String
	var z_index: int

	new_sprite = PackedSceneData.get_packed_scene(sub_tag).instance()
	sprite_color = Palette.get_default_color(main_tag)
	z_index = ZIndex.get_z_index(main_tag)

	new_sprite.position = ConvertCoord.coord_to_vector(coord, x_offset,
			y_offset)
	new_sprite.add_to_group(main_tag)
	new_sprite.add_to_group(sub_tag)
	new_sprite.z_index = z_index
	new_sprite.modulate = sprite_color

	add_child(new_sprite)
	StateManager.add_state(new_sprite, main_tag, sub_tag)
	for i in more_tags:
		new_sprite.add_to_group(i)
	emit_signal(SignalTag.SPRITE_CREATED, new_sprite)

	return new_sprite


func create_ground(sub_tag: String, coord: IntCoord, more_tags := []) -> void:
	create(MainTag.GROUND, sub_tag, coord, more_tags)


func create_trap(sub_tag: String, coord: IntCoord, more_tags := []) -> void:
	create(MainTag.TRAP, sub_tag, coord, more_tags)


func create_building(sub_tag: String, coord: IntCoord, more_tags := []) -> void:
	create(MainTag.BUILDING, sub_tag, coord, more_tags)


func create_actor(sub_tag: String, coord: IntCoord, more_tags := []) -> void:
	create(MainTag.ACTOR, sub_tag, coord, more_tags)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == ScreenTag.MAIN)
