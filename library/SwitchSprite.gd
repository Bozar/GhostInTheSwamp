class_name SwitchSprite


const NO_SPRITE_TAG := "Sprite [%s] does not have node [%s]."


static func set_sprite(sprite: Sprite, new_tag: String) -> void:
	var sprite_state := ObjectState.get_state(sprite)
	var current_tag := sprite_state.sprite_tag

	for i in [current_tag, new_tag]:
		if not sprite.has_node(i):
			push_warning(NO_SPRITE_TAG % [sprite.name, i])
			return

	sprite.get_node(current_tag).visible = false
	sprite.get_node(new_tag).visible = true
	sprite_state.sprite_tag = new_tag
