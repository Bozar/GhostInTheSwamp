extends Node2D
class_name CreateObject


const ERR_MSG := "Duplicate sprite. MainTag: %s, x: %s, y: %s."

signal sprite_created(basic_sprite_data)

var _ref_Palette: Palette
var _ref_DungeonBoard: DungeonBoard


func create_and_fetch_xy(main_tag: String, sub_tag: String, x: int, y: int,
		x_offset := 0, y_offset := 0) -> Sprite:
	var new_sprite: Sprite
	var new_basic: BasicSpriteData
	var sprite_color: String
	var z_index: int

	if _ref_DungeonBoard.has_sprite_xy(main_tag, x, y):
		push_error(ERR_MSG % [main_tag, x, y])
		return null

	new_sprite = PackedSceneData.get_packed_scene(sub_tag).instance()
	new_basic = BasicSpriteData.new(new_sprite, main_tag, sub_tag, x, y)
	sprite_color = _ref_Palette.get_default_color(main_tag)
	z_index = ZIndex.get_z_index(main_tag)

	new_sprite.position = ConvertCoord.xy_to_vector(x, y, x_offset, y_offset)
	new_sprite.add_to_group(main_tag)
	new_sprite.add_to_group(sub_tag)
	new_sprite.z_index = z_index
	new_sprite.modulate = sprite_color

	add_child(new_sprite)
	$ManageObjectState.add_state_node(new_basic)
	emit_signal(SignalTag.SPRITE_CREATED, new_basic)

	return new_sprite


func create_and_fetch(main_tag: String, sub_tag: String, coord: IntCoord,
		x_offset := 0, y_offset := 0) -> Sprite:
	return create_and_fetch_xy(main_tag, sub_tag, coord.x, coord.y,
			x_offset, y_offset)


func create_xy(main_tag: String, sub_tag: String, x: int, y: int,
		x_offset := 0, y_offset := 0) -> void:
	create_and_fetch_xy(main_tag, sub_tag, x, y, x_offset, y_offset)


func create(main_tag: String, sub_tag: String, coord: IntCoord,
		x_offset := 0, y_offset := 0) -> void:
	create_xy(main_tag, sub_tag, coord.x, coord.y, x_offset, y_offset)


func create_ground_xy(sub_tag: String, x: int, y: int) -> void:
	create_xy(MainTag.GROUND, sub_tag, x, y)


func create_ground(sub_tag: String, coord: IntCoord) -> void:
	create_ground_xy(sub_tag, coord.x, coord.y)


func create_trap_xy(sub_tag: String, x: int, y: int) -> void:
	create_xy(MainTag.TRAP, sub_tag, x, y)


func create_trap(sub_tag: String, coord: IntCoord) -> void:
	create_trap_xy(sub_tag, coord.x, coord.y)


func create_building_xy(sub_tag: String, x: int, y: int) -> void:
	create_xy(MainTag.BUILDING, sub_tag, x, y)


func create_building(sub_tag: String, coord: IntCoord) -> void:
	create_building_xy(sub_tag, coord.x, coord.y)


func create_actor_xy(sub_tag: String, x: int, y: int) -> void:
	create_xy(MainTag.ACTOR, sub_tag, x, y)


func create_actor(sub_tag: String, coord: IntCoord) -> void:
	create_actor_xy(sub_tag, coord.x, coord.y)


func create_and_fetch_actor_xy(sub_tag: String, x: int, y: int) -> Sprite:
	return create_and_fetch_xy(MainTag.ACTOR, sub_tag, x, y)


func create_and_fetch_actor(sub_tag: String, coord: IntCoord) -> Sprite:
	return create_and_fetch_actor_xy(sub_tag, coord.x, coord.y)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == ScreenTag.MAIN)
