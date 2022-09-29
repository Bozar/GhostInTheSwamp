extends Node2D
# class_name FindObject


const MULTIPLE_PC := "Find more than one PC object."
const NO_PC := "Cannot find a PC object."

var pc: Sprite setget _set_none, get_pc
var pc_coord: IntCoord setget _set_none, get_pc_coord
var pc_state: PcState setget _set_none, get_pc_state


# There should be only one sprite in the group `SubTag.PC`.
# The PC sprite should not be removed throughout the game.
func get_pc() -> Sprite:
	var find_pc: Array

	if pc == null:
		find_pc = get_sprites_with_tag(SubTag.PC)
		if find_pc.size() > 1:
			push_warning(MULTIPLE_PC)
		elif find_pc.size() == 0:
			push_warning(NO_PC)
		return find_pc.pop_back()
	return pc


func get_pc_coord() -> IntCoord:
	return ConvertCoord.sprite_to_coord(get_pc())


func get_pc_state() -> PcState:
	return ObjectState.get_state(get_pc()) as PcState


func get_npc_count() -> int:
	return FindObject.get_sprites_with_tag(MainTag.ACTOR).size() - 1


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
func get_sprites_with_tag(tag: String) -> Array:
	var sprites := get_tree().get_nodes_in_group(tag)
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
	ArrayHelper.filter_element(sprites, self, "_is_not_queue_free")
	return sprites
	# return get_tree().get_nodes_in_group(tag)


func get_sprite(tag: String, coord: IntCoord, try_dungeon_board := true,
		only_one_sprite := true, out_stacked := []) -> Sprite:
	if try_dungeon_board and (tag in MainTag.DUNGEON_OBJECT):
		return DungeonBoard.get_by_coord(tag, coord)

	var sprites := get_sprites_with_tag(tag)
	var source_size := out_stacked.size()
	var this_coord: IntCoord

	for i in sprites:
		this_coord = ConvertCoord.sprite_to_coord(i)
		if CoordCalculator.is_same_coord(this_coord, coord):
			if only_one_sprite:
				return i
			else:
				out_stacked.push_back(i)
	if source_size == out_stacked.size():
		return null
	return out_stacked.pop_back()


func has_sprite(tag: String, coord: IntCoord) -> bool:
	return get_sprite(tag, coord) != null


func get_ground(coord: IntCoord) -> Sprite:
	return get_sprite(MainTag.GROUND, coord)


func get_trap(coord: IntCoord) -> Sprite:
	return get_sprite(MainTag.TRAP, coord)


func get_building(coord: IntCoord) -> Sprite:
	return get_sprite(MainTag.BUILDING, coord)


func get_actor(coord: IntCoord) -> Sprite:
	return get_sprite(MainTag.ACTOR, coord)


func has_ground(coord: IntCoord) -> bool:
	return has_sprite(MainTag.GROUND, coord)


func has_trap(coord: IntCoord) -> bool:
	return has_sprite(MainTag.TRAP, coord)


func has_building(coord: IntCoord) -> bool:
	return has_sprite(MainTag.BUILDING, coord)


func has_actor(coord: IntCoord) -> bool:
	return has_sprite(MainTag.ACTOR, coord)


func get_ground_with_sub_tag(coord: IntCoord, sub_tag: String) -> Sprite:
	var sprite := get_ground(coord)

	if (sprite != null) and sprite.is_in_group(sub_tag):
		return sprite
	return null


func get_trap_with_sub_tag(coord: IntCoord, sub_tag: String) -> Sprite:
	var sprite := get_trap(coord)

	if (sprite != null) and sprite.is_in_group(sub_tag):
		return sprite
	return null


func get_building_with_sub_tag(coord: IntCoord, sub_tag: String) -> Sprite:
	var sprite := get_building(coord)

	if (sprite != null) and sprite.is_in_group(sub_tag):
		return sprite
	return null


func get_actor_with_sub_tag(coord: IntCoord, sub_tag: String) -> Sprite:
	var sprite := get_actor(coord)

	if (sprite != null) and sprite.is_in_group(sub_tag):
		return sprite
	return null


func has_ground_with_sub_tag(coord: IntCoord, sub_tag: String) -> bool:
	return get_ground_with_sub_tag(coord, sub_tag) != null


func has_trap_with_sub_tag(coord: IntCoord, sub_tag: String) -> bool:
	return get_trap_with_sub_tag(coord, sub_tag) != null


func has_building_with_sub_tag(coord: IntCoord, sub_tag: String) -> bool:
	return get_building_with_sub_tag(coord, sub_tag) != null


func has_actor_with_sub_tag(coord: IntCoord, sub_tag: String) -> bool:
	return get_actor_with_sub_tag(coord, sub_tag) != null


func _is_not_queue_free(source: Array, index: int, _opt: Array) -> bool:
	return not source[index].is_queued_for_deletion()


func _set_none(__) -> void:
	return
