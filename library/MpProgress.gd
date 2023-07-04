class_name MpProgress


static func renew_world(cast_results: Dictionary, ref_random: RandomNumber) \
		-> void:
	if _has_actor_in_line(cast_results):
		_set_mp_progress(ref_random)


static func _has_actor_in_line(cast_results: Dictionary) -> bool:
	for i in cast_results.values():
		if i[CastRay.LAST_SPRITE].is_in_group(MainTag.ACTOR):
			return true
	return false


static func _set_mp_progress(ref_random: RandomNumber) -> void:
	var pc_state := FindObject.pc_state
	var count_harbor: int = 0
	var add_progress: int
	var collide_reduction: int
	var min_reduction: int = PcData.HARBOR_TO_MP_PROGRESS[1]
	var max_reduction: int = PcData.HARBOR_TO_MP_PROGRESS[2] + 1

	# Count active harbors.
	for i in FindObjectHelper.get_harbors():
		if (ObjectState.get_state(i) as HarborState).is_active:
			count_harbor += 1
	count_harbor = min(count_harbor, PcData.MAX_VALID_HARBOR) as int
	# Increase MP progress based on the number of active harbors.
	add_progress = PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)

	# MP restores slower due to actors collision.
	if pc_state.actor_collision > 0:
		pc_state.actor_collision -= 1
		collide_reduction = ref_random.get_int(min_reduction, max_reduction)

	add_progress -= collide_reduction
	add_progress = max(0, add_progress) as int
	pc_state.mp_progress += add_progress
