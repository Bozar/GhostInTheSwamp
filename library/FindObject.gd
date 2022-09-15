extends Node2D
class_name Game_FindObject


var pc: Sprite setget set_pc, get_pc
var pc_coord: Game_IntCoord setget set_pc_coord, get_pc_coord
var npc: Array setget set_npc, get_npc
var count_npc: int setget set_count_npc, get_count_npc


# There should be only one sprite in the group `Game_SubTag.PC`.
# The PC sprite should not be removed throughout the game.
func get_pc() -> Sprite:
	var find_pc: Array

	if pc == null:
		find_pc = get_sprites_by_tag(Game_SubTag.PC)
		if find_pc.size() > 0:
			pc = find_pc[0]
	return pc


func get_pc_coord() -> Game_IntCoord:
	return Game_ConvertCoord.sprite_to_coord(get_pc())


func get_npc() -> Array:
	var all_actors := get_sprites_by_tag(Game_MainTag.ACTOR)
	Game_ArrayHelper.filter_element(all_actors, self, "_filter_get_npc")
	return all_actors


func get_count_npc() -> int:
	return get_npc().size()


func set_pc(__: Sprite) -> void:
	pass


func set_pc_coord(__: Game_IntCoord) -> void:
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
	Game_ArrayHelper.filter_element(sprites, self, "_filter_get_sprites_by_tag")
	return sprites
	# return get_tree().get_nodes_in_group(tag)


func _filter_get_sprites_by_tag(source: Array, index: int, _opt: Array) -> bool:
	return not source[index].is_queued_for_deletion()


func _filter_get_npc(source: Array, index: int, _opt: Array) -> bool:
	return not (source[index].is_queued_for_deletion() \
			or source[index].is_in_group(Game_SubTag.PC))
