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
