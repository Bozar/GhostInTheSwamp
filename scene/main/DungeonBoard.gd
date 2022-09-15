extends Node2D
class_name DungeonBoard


const ERR_SPRITE := ": MainTag: {0}, Coord: ({1}, {2})."
const ERR_NO_SPRITE := "No sprite" + ERR_SPRITE
const ERR_HAS_SPRITE := "Has sprite" + ERR_SPRITE
const MAIN_TAG_WITH_LAYER := "%s_%s"

const SUB_TAG_TO_SPRITE := {
	SubTag.ARROW_RIGHT: null,
	SubTag.ARROW_DOWN: null,
	SubTag.ARROW_UP: null,
}

var pc: Sprite setget set_pc, get_pc
var pc_coord: IntCoord setget set_pc_coord, get_pc_coord
var npc: Array setget set_npc, get_npc
var count_npc: int setget set_count_npc, get_count_npc

# <main_tag: String, <column: int, [sprite]>>
var _sprite_dict := {}


func _ready() -> void:
	pass


func has_sprite_xy(main_tag: String, x: int, y: int) -> bool:
	return get_sprite_xy(main_tag, x, y) != null


func has_sprite(main_tag: String, coord: IntCoord) -> bool:
	return has_sprite_xy(main_tag, coord.x, coord.y)


func has_sprite_with_sub_tag_xy(main_tag: String, sub_tag: String,
		x: int, y: int) -> bool:
	var find_sprite: Sprite
	var find_in_main_tags: Array

	if main_tag == "":
		find_in_main_tags = MainTag.DUNGEON_OBJECT
	else:
		find_in_main_tags = [main_tag]

	for i in find_in_main_tags:
		find_sprite = get_sprite_xy(i, x, y)
		if (find_sprite != null) and find_sprite.is_in_group(sub_tag):
			return true
	return false


func has_sprite_with_sub_tag(main_tag: String, sub_tag: String,
		coord: IntCoord) -> bool:
	return has_sprite_with_sub_tag_xy(main_tag, sub_tag, coord.x, coord.y)


func get_sprite_xy(main_tag: String, x: int, y: int) -> Sprite:
	var new_tag := _try_convert_main_tag(main_tag)

	if not CoordCalculator.is_inside_dungeon(x, y):
		return null
	elif not _sprite_dict.has(new_tag):
		return null
	elif not _sprite_dict[new_tag].has(x):
		return null
	return _get_dict_value(new_tag, x, y)


func get_sprite(main_tag: String, coord: IntCoord) -> Sprite:
	return get_sprite_xy(main_tag, coord.x, coord.y)


# There should be only one sprite in the group `SubTag.PC`.
# The PC sprite should not be removed throughout the game.
func get_pc() -> Sprite:
	var find_pc: Array

	if pc == null:
		find_pc = get_sprites_by_tag(SubTag.PC)
		if find_pc.size() > 0:
			pc = find_pc[0]
	return pc


func get_pc_coord() -> IntCoord:
	return ConvertCoord.sprite_to_coord(get_pc())


func get_npc() -> Array:
	var all_actors := get_sprites_by_tag(MainTag.ACTOR)
	ArrayHelper.filter_element(all_actors, self, "_filter_get_npc", [])
	return all_actors


func get_count_npc() -> int:
	return get_npc().size()


func set_pc(__: Sprite) -> void:
	pass


func set_pc_coord(__: IntCoord) -> void:
	pass


func set_npc(__: Array) -> void:
	pass


func set_count_npc(__: int) -> void:
	pass


# When we call `foobar.queue_free()`, the node foobar will be deleted at the end
# of the current frame if there are no references to it.
#
# However, if we set a reference to foobar in the same frame by, let's say,
# `get_tree().get_nodes_in_group()`, foobar will not be deleted when the current
# frame ends.
#
# Therefore, after calling `get_tree().get_nodes_in_group()`, we need to check
# if such nodes will be deleted with `foobar.is_queued_for_deletion()` to avoid
# potential bugs.
#
# You can reproduce such a bug in v0.1.3 with the seed 1888400396. Refer to this
# video for more information.
#
# https://youtu.be/agqdag6GqpU
func get_sprites_by_tag(tag: String) -> Array:
	var sprites: Array = get_tree().get_nodes_in_group(tag)
	# var verify: Sprite
	# var counter: int = 0

	# Filter elements in a more efficent way based on `u/kleonc`'s suggestion.
	# https://www.reddit.com/r/godot/comments/kq4c91/beware_that_foobarqueue_free_removes_foobar_at/gi3femf
	# for i in range(sprites.size()):
	# 	verify = sprites[i]
	# 	if verify.is_queued_for_deletion():
	# 		continue
	# 	sprites[counter] = verify
	# 	counter += 1
	# sprites.resize(counter)
	ArrayHelper.filter_element(sprites, self, "_filter_get_sprites_by_tag",
			[])
	return sprites
	# return get_tree().get_nodes_in_group(tag)


func get_actor_xy(x: int, y: int) -> Sprite:
	return get_sprite_xy(MainTag.ACTOR, x, y)


func has_actor_xy(x: int, y: int) -> bool:
	return has_sprite_xy(MainTag.ACTOR, x, y)


func get_actor(coord: IntCoord) -> Sprite:
	return get_actor_xy(coord.x, coord.y)


func has_actor(coord: IntCoord) -> bool:
	return has_actor_xy(coord.x, coord.y)


func get_building_xy(x: int, y: int) -> Sprite:
	return get_sprite_xy(MainTag.BUILDING, x, y)


func has_building_xy(x: int, y: int) -> bool:
	return has_sprite_xy(MainTag.BUILDING, x, y)


func get_building(coord: IntCoord) -> Sprite:
	return get_building_xy(coord.x, coord.y)


func has_building(coord: IntCoord) -> bool:
	return has_building_xy(coord.x, coord.y)


func get_trap_xy(x: int, y: int) -> Sprite:
	return get_sprite_xy(MainTag.TRAP, x, y)


func has_trap_xy(x: int, y: int) -> bool:
	return has_sprite_xy(MainTag.TRAP, x, y)


func get_trap(coord: IntCoord) -> Sprite:
	return get_trap_xy(coord.x, coord.y)


func has_trap(coord: IntCoord) -> bool:
	return has_trap_xy(coord.x, coord.y)


func get_ground_xy(x: int, y: int) -> Sprite:
	return get_sprite_xy(MainTag.GROUND, x, y)


func has_ground_xy(x: int, y: int) -> bool:
	return has_sprite_xy(MainTag.GROUND, x, y)


func get_ground(coord: IntCoord) -> Sprite:
	return get_ground_xy(coord.x, coord.y)


func has_ground(coord: IntCoord) -> bool:
	return has_ground_xy(coord.x, coord.y)


func move_sprite_xy(main_tag: String, source_x: int, source_y: int,
		target_x: int, target_y: int) -> void:
	var move_this := get_sprite_xy(main_tag, source_x, source_y)

	if move_this == null:
		push_error(ERR_NO_SPRITE.format([main_tag, source_x, source_y]))
		return
	elif has_sprite_xy(main_tag, target_x, target_y):
		push_error(ERR_HAS_SPRITE.format([main_tag, target_x, target_y]))
		return

	swap_sprite_xy(main_tag, source_x, source_y, target_x, target_y)


func move_sprite(main_tag: String, source: IntCoord,
		target: IntCoord) -> void:
	move_sprite_xy(main_tag, source.x, source.y, target.x, target.y)


func move_actor_xy(source_x: int, source_y: int, target_x: int, target_y: int) \
		-> void:
	move_sprite_xy(MainTag.ACTOR, source_x, source_y, target_x, target_y)


func move_actor(source: IntCoord, target: IntCoord) -> void:
	move_actor_xy(source.x, source.y, target.x, target.y)


func swap_sprite_xy(main_tag: String, source_x: int, source_y: int,
		target_x: int, target_y: int) -> void:
	var source_sprite := get_sprite_xy(main_tag, source_x, source_y)
	var target_sprite := get_sprite_xy(main_tag, target_x, target_y)
	var new_tag := _try_convert_main_tag(main_tag)

	_move_dict_value(new_tag, target_x, target_y, source_sprite)
	_move_dict_value(new_tag, source_x, source_y, target_sprite)


func swap_sprite(main_tag: String, source: IntCoord,
		target: IntCoord) -> void:
	swap_sprite_xy(main_tag, source.x, source.y, target.x, target.y)


func _on_CreateObject_sprite_created(sprite_data: BasicSpriteData) -> void:
	var new_tag: String

	# Save references to arrow indicators.
	if sprite_data.main_tag == MainTag.INDICATOR:
		for i in SUB_TAG_TO_SPRITE.keys():
			if i == sprite_data.sub_tag:
				SUB_TAG_TO_SPRITE[i] = sprite_data.sprite
	# Save references to dungeon sprites.
	else:
		for i in MainTag.DUNGEON_OBJECT:
			if i != sprite_data.main_tag:
				continue
			# new_tag = _try_convert_main_tag(i, sprite_data.sprite_layer)
			new_tag = _try_convert_main_tag(i)
			if not _sprite_dict.has(new_tag):
				_init_dict(new_tag)
			_set_dict_value(new_tag, sprite_data.x, sprite_data.y,
					sprite_data.sprite)


func _on_RemoveObject_sprite_removed(sprite_data: BasicSpriteData) -> void:
	var new_tag := _try_convert_main_tag(sprite_data.main_tag)
	_set_dict_value(new_tag, sprite_data.x, sprite_data.y, null)


func _init_dict(new_tag: String) -> void:
	_sprite_dict[new_tag] = {}
	for x in range(DungeonSize.MAX_X):
		_sprite_dict[new_tag][x] = []
		_sprite_dict[new_tag][x].resize(DungeonSize.MAX_Y)


# Move arrow indicators when PC moves.
func _try_move_arrow(sprite: Sprite) -> void:
	if not sprite.is_in_group(SubTag.PC):
		return

	SUB_TAG_TO_SPRITE[SubTag.ARROW_RIGHT].position.y = sprite.position.y
	SUB_TAG_TO_SPRITE[SubTag.ARROW_DOWN].position.x = sprite.position.x
	SUB_TAG_TO_SPRITE[SubTag.ARROW_UP].position.x = sprite.position.x


func _filter_get_sprites_by_tag(source: Array, index: int, _opt: Array) -> bool:
	return not source[index].is_queued_for_deletion()


func _filter_get_npc(source: Array, index: int, _opt: Array) -> bool:
	return not (source[index].is_queued_for_deletion() \
			or source[index].is_in_group(SubTag.PC))


func _try_convert_main_tag(main_tag: String) -> String:
	return main_tag
	# if sprite_layer == 0:
	# 	return main_tag
	# else:
	# 	return MAIN_TAG_WITH_LAYER % [main_tag]


func _get_dict_value(main_tag: String, x: int, y: int) -> Sprite:
	return _sprite_dict[main_tag][x][y]


func _set_dict_value(main_tag: String, x: int, y: int, sprite: Sprite) -> void:
	_sprite_dict[main_tag][x][y] = sprite


func _move_dict_value(main_tag: String, target_x: int, target_y: int,
		sprite: Sprite) -> void:
	_set_dict_value(main_tag, target_x, target_y, sprite)
	if sprite != null:
		sprite.position = ConvertCoord.xy_to_vector(target_x, target_y)
		_try_move_arrow(sprite)
