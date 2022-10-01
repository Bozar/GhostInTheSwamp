class_name HarborHelper


static func toggle_harbor(sprite: Sprite, is_active: bool) -> void:
	var new_sprite_type := SpriteTag.DEFAULT
	var state: HarborState = ObjectState.get_state(sprite)

	if is_active:
		new_sprite_type = SpriteTag.ACTIVE
	SwitchSprite.set_sprite(sprite, new_sprite_type)
	state.is_active = is_active


static func toggle_harbor_with_coord(coord: IntCoord, is_active: bool) -> void:
	var harbor_sprite := FindObjectHelper.get_harbor_with_coord(coord)
	toggle_harbor(harbor_sprite, is_active)


static func is_active(coord: IntCoord) -> bool:
	var harbor_sprite := FindObjectHelper.get_harbor_with_coord(coord)
	var harbor_state: HarborState

	if harbor_sprite != null:
		harbor_state = ObjectState.get_state(harbor_sprite)
		return harbor_state.is_active
	return false
