extends Node2D
class_name StartPcTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
]

var _ref_CreateObject: CreateObject


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	_add_actor()
	_add_ship()
	_add_dinghy()
	_set_mp_progress()
	_set_actor_fov()


func _set_mp_progress() -> void:
	var pc_state := ObjectState.get_state(FindObject.pc) as PcState
	var count_harbor := 0

	for i in FindObject.get_sprites_by_tag(SubTag.HARBOR):
		if (ObjectState.get_state(i) as BuildingState).is_active:
			count_harbor += 1
	pc_state.mp_progress += PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)


func _add_actor() -> void:
	pass


func _add_ship() -> void:
	pass


# Reduce countdown timer until a ghost appears.
func _add_dinghy() -> void:
	pass


func _set_actor_fov() -> void:
	pass
