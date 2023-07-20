class_name BasicSpriteData


var main_tag: String setget _set_none, _get_main_tag
var sub_tag: String setget _set_none, _get_sub_tag
var fov_memory := false
var sprite_tag: String = SpriteTag.DEFAULT
var coord: IntCoord setget _set_none, _get_coord

var _main_tag := ""
var _sub_tag := ""
var _self_sprite: Sprite


func _init(main_tag_: String, sub_tag_: String, sprite_: Sprite) -> void:
	_main_tag = main_tag_
	_sub_tag = sub_tag_
	_self_sprite = sprite_


func _get_main_tag() -> String:
	return _main_tag


func _get_sub_tag() -> String:
	return _sub_tag


func _get_coord() -> IntCoord:
	return ConvertCoord.sprite_to_coord(_self_sprite)


func _set_none(_value) -> void:
	return
