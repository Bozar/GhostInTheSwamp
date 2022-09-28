class_name ActorDropItem


static func get_sub_tag(actor_sub_tag: String, drop_rate: Dictionary,
		ref_random: RandomNumber) -> String:
	var trap_sub_tag: String = PcData.ACTOR_TO_TRAP.get(actor_sub_tag,
			SubTag.INVALID)
	var drop_this := false

	if trap_sub_tag == SubTag.INVALID:
		return SubTag.INVALID
	elif FindObject.pc_state.has_item(trap_sub_tag):
		return SubTag.INVALID
	elif FindObject.get_sprites_with_tag(trap_sub_tag).size() > 0:
		return SubTag.INVALID

	drop_this = ref_random.get_percent_chance(drop_rate[trap_sub_tag])
	if drop_rate[trap_sub_tag] < PcData.LOW_DROP_RATE:
		drop_rate[trap_sub_tag] += PcData.FAST_INCREASE_RATE
	elif drop_rate[trap_sub_tag] < PcData.MAX_DROP_RATE:
		drop_rate[trap_sub_tag] += PcData.INCREASE_RATE
	else:
		drop_rate[trap_sub_tag] = PcData.MAX_DROP_RATE

	if drop_this:
		return trap_sub_tag
	return SubTag.INVALID
