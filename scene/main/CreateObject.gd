extends Node2D
class_name Game_CreateObject


const ERR_MSG := "Duplicate sprite. MainTag: {0}, x: {1}, y: {2}, layer: {3}."

const SIG_SPRITE_CREATED := "sprite_created"

signal sprite_created(basic_sprite_data)

var _ref_Palette: Game_Palette
var _ref_DungeonBoard: Game_DungeonBoard


func create_and_fetch_xy(main_tag: String, sub_tag: String, x: int, y: int,
		sprite_layer := 0, x_offset := 0, y_offset := 0) -> Sprite:
	var new_sprite: Sprite = Game_PackedSceneData.get_packed_scene(sub_tag) \
			.instance() as Sprite
	var sprite_color: String = _ref_Palette.get_default_color(main_tag)
	var z_index: int = Game_ZIndex.get_z_index(main_tag)

	if _ref_DungeonBoard.has_sprite_xy(main_tag, x, y, sprite_layer):
		push_error(ERR_MSG.format([main_tag, String(x), String(y),
				String(sprite_layer)]))
		return null

	new_sprite.position = Game_ConvertCoord.coord_to_vector(x, y,
			x_offset, y_offset)
	new_sprite.add_to_group(main_tag)
	new_sprite.add_to_group(sub_tag)
	new_sprite.z_index = z_index
	new_sprite.modulate = sprite_color

	add_child(new_sprite)
	emit_signal(SIG_SPRITE_CREATED, Game_BasicSpriteData.new(new_sprite,
			main_tag, sub_tag, x, y, sprite_layer))
	return new_sprite


func create_and_fetch(main_tag: String, sub_tag: String, coord: Game_IntCoord,
		sprite_layer := 0, x_offset := 0, y_offset := 0) -> Sprite:
	return create_and_fetch_xy(main_tag, sub_tag, coord.x, coord.y,
			sprite_layer, x_offset, y_offset)


func create_xy(main_tag: String, sub_tag: String, x: int, y: int,
		sprite_layer := 0, x_offset := 0, y_offset := 0) -> void:
	create_and_fetch_xy(main_tag, sub_tag, x, y, sprite_layer,
			x_offset, y_offset)


func create(main_tag: String, sub_tag: String, coord: Game_IntCoord,
		sprite_layer := 0, x_offset := 0, y_offset := 0) -> void:
	create_xy(main_tag, sub_tag, coord.x, coord.y, sprite_layer,
			x_offset, y_offset)


func create_ground_xy(sub_tag: String, x: int, y: int, sprite_layer := 0) \
		-> void:
	create_xy(Game_MainTag.GROUND, sub_tag, x, y, sprite_layer)


func create_ground(sub_tag: String, coord: Game_IntCoord, sprite_layer := 0) \
		-> void:
	create_ground_xy(sub_tag, coord.x, coord.y, sprite_layer)


func create_trap_xy(sub_tag: String, x: int, y: int, sprite_layer := 0) -> void:
	create_xy(Game_MainTag.TRAP, sub_tag, x, y, sprite_layer)


func create_trap(sub_tag: String, coord: Game_IntCoord, sprite_layer := 0) \
		-> void:
	create_trap_xy(sub_tag, coord.x, coord.y, sprite_layer)


func create_building_xy(sub_tag: String, x: int, y: int, sprite_layer := 0) \
		-> void:
	create_xy(Game_MainTag.BUILDING, sub_tag, x, y, sprite_layer)


func create_building(sub_tag: String, coord: Game_IntCoord, sprite_layer := 0) \
		-> void:
	create_building_xy(sub_tag, coord.x, coord.y, sprite_layer)


func create_actor_xy(sub_tag: String, x: int, y: int, sprite_layer := 0) \
		-> void:
	create_xy(Game_MainTag.ACTOR, sub_tag, x, y, sprite_layer)


func create_actor(sub_tag: String, coord: Game_IntCoord, sprite_layer := 0) \
		-> void:
	create_actor_xy(sub_tag, coord.x, coord.y, sprite_layer)


func create_and_fetch_actor_xy(sub_tag: String, x: int, y: int,
		sprite_layer := 0) -> Sprite:
	return create_and_fetch_xy(Game_MainTag.ACTOR, sub_tag, x, y,
			sprite_layer)


func create_and_fetch_actor(sub_tag: String, coord: Game_IntCoord,
		sprite_layer := 0) -> Sprite:
	return create_and_fetch_actor_xy(sub_tag, coord.x, coord.y,
			sprite_layer)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == Game_ScreenTag.MAIN)
