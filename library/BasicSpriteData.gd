extends Node2D
class_name BasicSpriteData


var main_tag: String setget set_main_tag, get_main_tag
var sub_tag: String setget set_sub_tag, get_sub_tag


func _init(main_tag_: String, sub_tag_: String) -> void:
	main_tag = main_tag_
	sub_tag = sub_tag_


func get_main_tag() -> String:
	return main_tag


func set_main_tag(__: String) -> void:
	pass


func get_sub_tag() -> String:
	return sub_tag


func set_sub_tag(__: String) -> void:
	pass
