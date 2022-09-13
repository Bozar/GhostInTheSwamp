extends Game_ObjectStateTemplate
class_name Game_BuildingState


func harbor_is_active(id: int) -> bool:
	if not _id_to_state.has(id):
		_id_to_state[id] = false
	return _id_to_state[id]


func set_harbor(id: int, is_active: bool) -> void:
	_id_to_state[id] = is_active
