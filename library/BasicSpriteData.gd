class_name BasicSpriteData


var sprite: Sprite setget set_sprite, get_sprite
var main_tag: String setget set_main_tag, get_main_tag
var sub_tag: String setget set_sub_tag, get_sub_tag
var x: int setget set_x, get_x
var y: int setget set_y, get_y


func _init(sprite_: Sprite, main_tag_: String, sub_tag_: String, x_: int,
		y_: int) -> void:
	sprite = sprite_
	main_tag = main_tag_
	sub_tag = sub_tag_
	x = x_
	y = y_


func get_sprite() -> Sprite:
	return sprite


func set_sprite(__: Sprite) -> void:
	return


func get_main_tag() -> String:
	return main_tag


func set_main_tag(__: String) -> void:
	return


func get_sub_tag() -> String:
	return sub_tag


func set_sub_tag(__: String) -> void:
	return


func get_x() -> int:
	return x


func set_x(__: int) -> void:
	return


func get_y() -> int:
	return y


func set_y(__: int) -> void:
	return
