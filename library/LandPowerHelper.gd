class_name LandPowerHelper


static func set_power(cast_results: Dictionary) -> void:
	var first_tag: String
	var last_sprite: Sprite

	for i in cast_results.keys():
		first_tag = cast_results[i][CastRayTag.FIRST_TAG]
		last_sprite = cast_results[i][CastRayTag.LAST_SPRITE]
		match ObjectState.get_state(last_sprite).main_tag:
			MainTag.ACTOR:
				_set_actor_power(i, first_tag, last_sprite)
			MainTag.TRAP:
				_set_trap_power(i, last_sprite)
			MainTag.BUILDING:
				_set_building_power(i, first_tag, last_sprite)


static func _get_spook_cost(pc_state: PcState, actor: Sprite) -> int:
	var actor_state := ObjectState.get_state(actor) as ActorState
	var cost: int = PcData.COST_SUB_TAG_TO_SPOOK[actor_state.sub_tag]

	if pc_state.count_item > 1:
		cost += PcData.COST_SPOOK_WITH_TWO_ITEMS

	var pc_coord := pc_state.coord
	var actor_coord := actor_state.coord
	var pc_to_actor := CoordCalculator.get_ray_direction(pc_coord, actor_coord)
	var actor_to_pc := actor_state.face_direction

	if (actor_to_pc == DirectionTag.NO_DIRECTION) or (pc_to_actor == actor_to_pc):
		cost -= PcData.COST_SPOOK_FROM_BEHIND
	elif not DirectionTag.is_opposite_direction(pc_to_actor, actor_to_pc):
		cost -= PcData.COST_SPOOK_FROM_SIDE

	return max(cost, 0) as int


static func _set_actor_power(direction: int, first_tag: String,
		last_sprite: Sprite) -> void:
	var pc_state := FindObject.pc_state

	# Swap with an actor.
	if first_tag == SubTag.SWAMP:
		if pc_state.has_ghost and pc_state.has_parrot():
			pc_state.set_power_tag(direction, PowerTag.SWAP)
			pc_state.set_target_sprite(direction, last_sprite)
	# Spook an actor.
	elif pc_state.mp > 0:
		pc_state.set_power_tag(direction, PowerTag.SPOOK)
		pc_state.set_power_cost(direction, _get_spook_cost(pc_state, last_sprite))
		pc_state.set_target_sprite(direction, last_sprite)


static func _set_trap_power(direction: int, last_sprite: Sprite) -> void:
	var pc_state := FindObject.pc_state

	# Pick up an item.
	pc_state.set_power_tag(direction, PowerTag.PICK)
	pc_state.set_target_sprite(direction, last_sprite)


static func _set_building_power(direction: int, first_tag: String,
		last_sprite: Sprite) -> void:
	var pc_state := FindObject.pc_state
	var sprite_state := ObjectState.get_state(last_sprite)

	match first_tag:
		# Light a harbor.
		SubTag.HARBOR:
			if pc_state.has_ghost:
				pc_state.set_power_tag(direction, PowerTag.LIGHT)
				pc_state.set_target_sprite(direction, last_sprite)
		# Embark on a dinghy.
		SubTag.DINGHY:
			pc_state.set_power_tag(direction, PowerTag.EMBARK)
			pc_state.set_target_sprite(direction, last_sprite)
		# Light or teleport to a harbor.
		SubTag.SWAMP:
			if pc_state.has_ghost and pc_state.has_parrot():
				if sprite_state.is_active:
					pc_state.set_power_tag(direction, PowerTag.TELEPORT)
				else:
					pc_state.set_power_tag(direction, PowerTag.LIGHT)
				pc_state.set_target_sprite(direction, last_sprite)
