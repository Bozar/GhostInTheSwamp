extends Node2D
class_name ObjectState


const WARN_SET_TWICE := "State set twice: MainTag: %s, SubTag: %s."

var store_state: StoreStateTemplate setget set_store_state, get_store_state


func get_store_state() -> StoreStateTemplate:
	return store_state


func set_store_state(new_state: StoreStateTemplate) -> void:
	if store_state == null:
		store_state = new_state
	else:
		push_warning(WARN_SET_TWICE % [new_state.main_tag, new_state.sub_tag])
