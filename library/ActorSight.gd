class_name ActorSight


# Change a sprite to an arrow that shows sight direction or back to normal.
static func toggle_actor(sprite: Sprite, show_sight: bool) -> void:
	var state := ObjectState.get_state(sprite) as ActorState
	var new_tag := SpriteTag.DEFAULT

	if show_sight:
		new_tag = DirectionTag.get_sprite_by_direction(state.face_direction)
	SwitchSprite.set_sprite(sprite, new_tag)
	state.show_sight = show_sight


# Change all actor sprites and set PC state.
static func toggle_sight_mode(exit_sight_mode := false) -> void:
	var state := FindObject.pc_state

	if exit_sight_mode:
		state.show_sight = false
	else:
		state.show_sight = not state.show_sight
	for i in FindObject.get_sprites_with_tag(MainTag.ACTOR):
		if i.is_in_group(SubTag.PC):
			continue
		toggle_actor(i, state.show_sight)


static func set_sight_around_pc(cast_results: Dictionary) -> void:
	var pc_coord := FindObject.pc_coord
	var has_actor: bool
	var first_tag: String
	var actor: Sprite
	var actor_state: ActorState
	var actor_coord: IntCoord
	var actor_sight: int
	var pc_to_actor: int
	var actor_to_pc: int

	for i in cast_results.keys():
		has_actor = false
		first_tag = cast_results[i][PcCastRay.FIRST_TAG]
		actor = cast_results[i][PcCastRay.LAST_SPRITE]
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
		actor_sight = ActorData.SIGHT_RANGE[actor_state.sub_tag]
		if CoordCalculator.is_out_of_range(pc_coord, actor_coord, actor_sight):
			continue

		pc_to_actor = CoordCalculator.get_ray_direction(pc_coord, actor_coord)
		actor_to_pc = actor_state.face_direction
		# In ActorAction, use PC's current position as destination and set
		# detect_pc to false.
		if DirectionTag.is_opposite_direction(pc_to_actor, actor_to_pc):
			FindObject.pc_state.set_npc_sight(pc_to_actor, true)
			actor_state.detect_pc = true
			actor_state.last_seen_pc_coord = pc_coord
		# A performer can sense PC without sight contact.
		elif actor.is_in_group(SubTag.PERFORMER):
			actor_state.detect_pc = true
			actor_state.last_seen_pc_coord = pc_coord
