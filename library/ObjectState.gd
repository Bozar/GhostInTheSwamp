extends StateManagerTemplate
# class_name ObjectState


const WARN_SET_TWICE := "State set twice: MainTag: %s, SubTag: %s."
const NO_STATE := "%s has no data in ObjectState."

const SUB_TAG_TO_STATE := {
	SubTag.PC: PcState,
}
const MAIN_TAG_TO_STATE := {
	MainTag.BUILDING: BuildingState,
}

var _id_to_state := {}


# Any sprite created by CreateObject has a record in _id_to_state.
func add_state(sprite: Sprite, main_tag: String, sub_tag: String) -> void:
	var id := _get_id(sprite)
	var new_state: BasicSpriteData

	if _id_to_state.has(id):
		push_warning(WARN_SET_TWICE % [main_tag, sub_tag])
		return

	if SUB_TAG_TO_STATE.has(sub_tag):
		new_state = SUB_TAG_TO_STATE[sub_tag].new(main_tag, sub_tag)
	elif MAIN_TAG_TO_STATE.has(main_tag):
		new_state = MAIN_TAG_TO_STATE[main_tag].new(main_tag, sub_tag)
	else:
		new_state = BasicSpriteData.new(main_tag, sub_tag)
	_id_to_state[id] = new_state


func get_state(sprite: Sprite) -> BasicSpriteData:
	var store_state: BasicSpriteData = _id_to_state.get(_get_id(sprite))

	if store_state == null:
		push_error(NO_STATE % sprite.name)
	return store_state


func remove_state(sprite: Sprite) -> void:
	var id := _get_id(sprite)

	# An object needs to be freed manually.
	_id_to_state[id].queue_free()
	_id_to_state.erase(id)


func remove_all() -> void:
	for i in _id_to_state.values():
		i.queue_free()
	_id_to_state.clear()


func _get_id(sprite: Sprite) -> int:
	return sprite.get_instance_id()
