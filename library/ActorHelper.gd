class_name ActorHelper


static func toggle_actor(sprite: Sprite, show_arrow: bool) -> void:
	var state := ObjectState.get_state(sprite) as ActorState
	var new_tag := SpriteTag.DEFAULT

	if show_arrow:
		new_tag = DirectionTag.get_sprite_by_direction(state.face_direction)
	SwitchSprite.set_sprite(sprite, new_tag)
	state.show_arrow = show_arrow


static func toggle_sight_mode() -> void:
	var state: ActorState

	for i in FindObject.get_sprites_with_tag(MainTag.ACTOR):
		if i.is_in_group(SubTag.PC):
			continue
		state = ObjectState.get_state(i)
		toggle_actor(i, not state.show_arrow)


static func exit_sight_mode() -> void:
	for i in FindObject.get_sprites_with_tag(MainTag.ACTOR):
		if i.is_in_group(SubTag.PC):
			continue
		toggle_actor(i, false)


static func set_sight_around_pc(cast_results: Dictionary) -> void:
	var pc_coord := FindObject.pc_coord
	var has_actor: bool
	var first_tag: String
	var actor: Sprite
	var actor_coord: IntCoord
	var actor_state: ActorState
	var pc_to_actor: int
	var actor_to_pc: int

	for i in cast_results.keys():
		has_actor = false
		first_tag = cast_results[i][CastRayTag.FIRST_TAG]
		actor = cast_results[i][CastRayTag.LAST_SPRITE]
		match first_tag:
			MainTag.ACTOR:
				has_actor = true
			SubTag.LAND:
				if (actor != null) and actor.is_in_group(MainTag.ACTOR):
					has_actor = true
		if not has_actor:
			continue

		actor_state = ObjectState.get_state(actor)
		actor_coord = actor_state.coord
		if CoordCalculator.is_out_of_range(pc_coord, actor_coord,
				PcData.SIGHT_RANGE - 1):
			continue

		pc_to_actor = CoordCalculator.get_ray_direction(pc_coord, actor_coord)
		actor_to_pc = actor_state.face_direction
		if DirectionTag.is_opposite_direction(pc_to_actor, actor_to_pc):
			FindObject.pc_state.set_npc_sight(pc_to_actor, true)
			actor_state.detect_pc = true
