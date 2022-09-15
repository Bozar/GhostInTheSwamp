extends Node2D
class_name ObjectState


const WARN_SET_TWICE := "State set twice: MainTag: %s, SubTag: %s."

const SUB_TAG_TO_STATE := {
	SubTag.PC: PcState,
}
const MAIN_TAG_TO_STATE := {
	MainTag.BUILDING: BuildingState,
}

const ID_TO_STATE := {}


static func add_state(sprite_data: BasicSpriteData) -> void:
	var this_sprite := sprite_data.sprite
	var main_tag := sprite_data.main_tag
	var sub_tag := sprite_data.sub_tag
	var id := _get_id(this_sprite)

	if ID_TO_STATE.has(id):
		push_warning(WARN_SET_TWICE % [main_tag, sub_tag])
		return

	if SUB_TAG_TO_STATE.has(sub_tag):
		ID_TO_STATE[id] = SUB_TAG_TO_STATE[sub_tag].new(sprite_data)
	elif MAIN_TAG_TO_STATE.has(main_tag):
		ID_TO_STATE[id] = MAIN_TAG_TO_STATE[main_tag].new(sprite_data)


static func get_state(sprite: Sprite) -> StoreStateTemplate:
	var id := _get_id(sprite)

	if ID_TO_STATE.has(id):
		return ID_TO_STATE[id]
	return null


static func remove_state(sprite: Sprite) -> void:
	var id := _get_id(sprite)

	# An object needs to be freed manually.
	ID_TO_STATE[id].queue_free()
	ID_TO_STATE.erase(id)


static func remove_all() -> void:
	for i in ID_TO_STATE.values():
		i.queue_free()
	ID_TO_STATE.clear()


static func _get_id(sprite: Sprite) -> int:
	return sprite.get_instance_id()
