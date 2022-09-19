extends Node2D
class_name StartPcTurn


var _harbor_sprites: Array


func set_reference() -> void:
	_harbor_sprites = FindObject.get_sprites_by_tag(SubTag.HARBOR)


func renew_world() -> void:
	_set_mp_progress()


func _set_mp_progress() -> void:
	var pc_state := ObjectState.get_state(FindObject.pc)
	var count_harbor := 0

	for i in _harbor_sprites:
		if (ObjectState.get_state(i) as BuildingState).is_active:
			count_harbor += 1
	pc_state.mp_progress += PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)
