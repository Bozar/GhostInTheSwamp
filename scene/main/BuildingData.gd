extends Node2D
class_name Game_BuildingData


var _id_to_harbor := {}


func harbor_is_active(id: int) -> bool:
	if not _id_to_harbor.has(id):
		_id_to_harbor[id] = false
	return _id_to_harbor[id]


func set_harbor(id: int, is_active: bool) -> void:
	_id_to_harbor[id] = is_active
