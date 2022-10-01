class_name ActorDropItem


static func get_sub_tag(actor_sub_tag: String, ref_random: RandomNumber) \
		-> String:
	var trap_sub_tag: String = PcData.ACTOR_TO_TRAP.get(actor_sub_tag,
			SubTag.INVALID)
	var add_score := 0
	var state := FindObject.pc_state

	if trap_sub_tag == SubTag.INVALID:
		return SubTag.INVALID
	elif state.has_item(trap_sub_tag):
		return SubTag.INVALID
	elif FindObject.get_sprites_with_tag(trap_sub_tag).size() > 0:
		return SubTag.INVALID

	add_score = ref_random.get_int(PcData.LOW_DROP_SCORE, PcData.HIGH_DROP_SCORE)
	state.add_drop_score(trap_sub_tag, add_score)
	if state.get_drop_score(trap_sub_tag) < PcData.MAX_DROP_SCORE:
		return SubTag.INVALID
	for i in state.get_item_tags():
		state.add_drop_score(i, -PcData.LOW_DROP_SCORE)
	return trap_sub_tag
