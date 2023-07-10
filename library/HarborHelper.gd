class_name HarborHelper


const MIN_DOUBLE_DIGIT: int = 10
const STATE_TO_SPRITE := {
	# Lock: fasle, active: false
	0: SpriteTag.DEFAULT,
	# Lock: fasle, active: true
	1: SpriteTag.ACTIVE,
	# Lock: true, active: false
	10: SpriteTag.LOCKED_DEFAULT,
	# Lock: true, active: true
	11: SpriteTag.LOCKED_ACTIVE,
}


static func set_sprite(harbor: Sprite) -> void:
	var state: HarborState = ObjectState.get_state(harbor)
	var int_state: int = 0
	var new_tag: String

	if state.is_active:
		int_state += 1
	if state.is_locked:
		int_state += 10
	new_tag = STATE_TO_SPRITE[int_state]

	if FindObject.pc_state.show_sight and state.is_locked \
			and (state.lock_counter < MIN_DOUBLE_DIGIT):
		new_tag = SpriteTag.convert_digit_to_tag(state.lock_counter)

	SwitchSprite.set_sprite(harbor, new_tag)


static func set_sprite_by_coord(coord: IntCoord) -> void:
	var harbor: Sprite = FindObjectHelper.get_harbor_by_coord(coord)
	if harbor != null:
		set_sprite(FindObjectHelper.get_harbor_by_coord(coord))


static func set_state(sprite: Sprite, is_active: bool) -> void:
	var state: HarborState = ObjectState.get_state(sprite)
	state.is_active = is_active


static func set_state_by_coord(coord: IntCoord, is_active: bool) -> void:
	var harbor: Sprite = FindObjectHelper.get_harbor_by_coord(coord)
	if harbor != null:
		set_state(harbor, is_active)


static func is_active(coord: IntCoord) -> bool:
	var sprite: Sprite = FindObjectHelper.get_harbor_by_coord(coord)
	var state: HarborState

	if sprite != null:
		state = ObjectState.get_state(sprite)
		return state.is_active
	return false


static func can_enter(harbor: Sprite) -> bool:
	var harbor_state: HarborState = ObjectState.get_state(harbor)
	var pc_state: PcState = FindObject.pc_state
	return (not harbor_state.is_locked) and pc_state.has_accordion()


static func can_enter_by_coord(coord: IntCoord) -> bool:
	var harbor: Sprite = FindObjectHelper.get_harbor_by_coord(coord)
	return (harbor != null) and can_enter(harbor)
