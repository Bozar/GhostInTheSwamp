class_name PcSpriteHelper


static func toggle_power_mode() -> void:
	var pc := FindObject.pc
	var state := ObjectState.get_state(pc)

	state.use_power = not state.use_power
	if state.use_power:
		SwitchSprite.set_sprite(pc, SpriteTag.USE_POWER)
	else:
		set_default_sprite()


static func exit_power_mode() -> void:
	ObjectState.get_state(FindObject.pc).use_power = false
	set_default_sprite()


static func set_default_sprite() -> void:
	var pc := FindObject.pc
	var coord := ConvertCoord.sprite_to_coord(pc)
	var state := ObjectState.get_state(pc)
	var building: Sprite
	var new_sprite := SpriteTag.DEFAULT

	if FindObjectHelper.has_harbor(coord):
		building = FindObjectHelper.get_harbor_with_coord(coord)
		if (ObjectState.get_state(building) as HarborState).is_active:
			new_sprite = SpriteTag.ACTIVE_HARBOR
		else:
			new_sprite = SpriteTag.DEFAULT_HARBOR
	elif FindObjectHelper.has_swamp(coord):
		if state.has_accordion():
			new_sprite = SpriteTag.SHIP
		else:
			new_sprite = SpriteTag.DINGHY
	SwitchSprite.set_sprite(pc, new_sprite)
