extends Node2D
class_name BasicSpriteData


var main_tag := "" setget _set_none, get_main_tag
var sub_tag := "" setget _set_none, get_sub_tag
var fov_memory := false setget set_fov_memory, get_fov_memory


func _init(main_tag_: String, sub_tag_: String) -> void:
	main_tag = main_tag_
	sub_tag = sub_tag_


func get_main_tag() -> String:
	return main_tag


func get_sub_tag() -> String:
	return sub_tag


func get_fov_memory() -> bool:
	return fov_memory


func set_fov_memory(new_data: bool) -> void:
	fov_memory = new_data


func _set_none(__) -> void:
	pass
