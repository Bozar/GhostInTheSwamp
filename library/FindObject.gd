extends Node2D
class_name FindObject


var pc: Sprite setget set_pc, get_pc
var pc_coord: IntCoord setget set_pc_coord, get_pc_coord


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


func set_pc(__: Sprite) -> void:
	pass


func set_pc_coord(__: IntCoord) -> void:
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
	ArrayHelper.filter_element(sprites, self, "_filter_get_sprites_by_tag")
	return sprites
	# return get_tree().get_nodes_in_group(tag)


func get_sprite(tag: String, coord: IntCoord, out_stacked := []) -> Sprite:
	var sprites := get_sprites_by_tag(tag)
	var source_size := out_stacked.size()
	var this_coord: IntCoord

	for i in sprites:
		this_coord = ConvertCoord.sprite_to_coord(i)
		if CoordCalculator.is_same_coord(this_coord, coord):
			out_stacked.push_back(i)
	if source_size == out_stacked.size():
		return null
	return out_stacked.pop_back()


func has_sprite(tag: String, coord: IntCoord) -> bool:
	return get_sprite(tag, coord) != null


func _filter_get_sprites_by_tag(source: Array, index: int, _opt: Array) -> bool:
	return not source[index].is_queued_for_deletion()
