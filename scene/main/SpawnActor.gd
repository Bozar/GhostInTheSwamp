extends Node2D
class_name SpawnActor


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
]

var _ref_CreateObject: CreateObject


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	pass
