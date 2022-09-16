class_name BasicSpriteData


var sprite: Sprite setget set_sprite, get_sprite
var main_tag: String setget set_main_tag, get_main_tag
var sub_tag: String setget set_sub_tag, get_sub_tag
var coord: IntCoord setget set_coord, get_coord


func _init(sprite_: Sprite, main_tag_: String, sub_tag_: String,
		coord_: IntCoord) -> void:
	sprite = sprite_
	main_tag = main_tag_
	sub_tag = sub_tag_
	coord = coord_


func get_sprite() -> Sprite:
	return sprite


func set_sprite(__: Sprite) -> void:
	pass


func get_main_tag() -> String:
	return main_tag


func set_main_tag(__: String) -> void:
	pass


func get_sub_tag() -> String:
	return sub_tag


func set_sub_tag(__: String) -> void:
	pass


func get_coord() -> IntCoord:
	return coord


func set_coord(__: IntCoord) -> void:
	pass
