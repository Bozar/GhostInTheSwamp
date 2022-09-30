class_name ActorDropItem


static func get_sub_tag(actor_sub_tag: String, drop_score: Dictionary,
		ref_random: RandomNumber) -> String:
	var trap_sub_tag: String = PcData.ACTOR_TO_TRAP.get(actor_sub_tag,
			SubTag.INVALID)
	var add_score := 0

	if trap_sub_tag == SubTag.INVALID:
		return SubTag.INVALID
	elif FindObject.pc_state.has_item(trap_sub_tag):
		return SubTag.INVALID
	elif FindObject.get_sprites_with_tag(trap_sub_tag).size() > 0:
		return SubTag.INVALID

	add_score = ref_random.get_int(PcData.LOW_DROP_SCORE, PcData.HIGH_DROP_SCORE)
	drop_score[trap_sub_tag] += add_score
	if drop_score[trap_sub_tag] >= PcData.MAX_DROP_SCORE:
		return trap_sub_tag
	return SubTag.INVALID
