class_name ActorCollision


static func set_remove_self(source_actor: Sprite, target_actor: Sprite) -> void:
	var save_actor := []

	if _compare_detect_pc(source_actor, target_actor, save_actor):
		_set_collided_actor(save_actor.pop_back())
	elif _compare_collsion_score(source_actor, target_actor, save_actor):
		_set_collided_actor(save_actor.pop_back())
	elif _compare_walk_path(source_actor, target_actor, save_actor):
		_set_collided_actor(save_actor.pop_back())
	else:
		_set_collided_actor(source_actor)


static func _set_collided_actor(actor: Sprite) -> void:
	var state: ActorState = ObjectState.get_state(actor)
	state.remove_self = true


static func _compare_collsion_score(source: Sprite, target: Sprite,
		out_actor: Array) -> bool:
	var source_sub_tag := ObjectState.get_state(source).sub_tag
	var source_score: int = ActorData.COLLISION_SCORE[source_sub_tag]
	var target_sub_tag := ObjectState.get_state(target).sub_tag
	var target_score: int = ActorData.COLLISION_SCORE[target_sub_tag]

	if source_score > target_score:
		out_actor.push_back(target)
		return true
	elif source_score < target_score:
		out_actor.push_back(source)
		return true
	return false


static func _compare_detect_pc(source: Sprite, target: Sprite, out_actor: Array) \
		-> bool:
	var state: ActorState

	for i in [source, target]:
		state = ObjectState.get_state(i)
		if not state.detect_pc:
			out_actor.push_back(i)
	if out_actor.size() == 1:
		return true
	out_actor.clear()
	return false


static func _compare_walk_path(source: Sprite, target: Sprite, out_actor: Array) \
		-> bool:
	var source_state: ActorState = ObjectState.get_state(source)
	var target_state: ActorState = ObjectState.get_state(target)
	# Do not compare arrays. This may result in `socket error: 10054`.
	var source_path := source_state.walk_path.size()
	var target_path := target_state.walk_path.size()

	if source_path > target_path:
		out_actor.push_back(source)
		return true
	elif source_path < target_path:
		out_actor.push_back(target)
		return true
	return false
