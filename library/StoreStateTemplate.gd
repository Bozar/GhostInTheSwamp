extends Node2D
class_name StoreStateTemplate


var main_tag: String setget set_main_tag, get_main_tag
var sub_tag: String setget set_sub_tag, get_sub_tag
var coord: IntCoord setget set_coord, get_coord
var x: int setget set_x, get_x
var y: int setget set_y, get_y

var _self_sprite: Sprite


func _init(basic_data: BasicSpriteData) -> void:
    main_tag = basic_data.main_tag
    sub_tag = basic_data.sub_tag
    _self_sprite = basic_data.sprite


func get_main_tag() -> String:
    return main_tag


func set_main_tag(__: String) -> void:
    pass


func get_sub_tag() -> String:
    return sub_tag


func set_sub_tag(__: String) -> void:
    pass


func get_coord() -> IntCoord:
    return ConvertCoord.sprite_to_coord(_self_sprite)


func set_coord(new_coord: IntCoord) -> void:
    _self_sprite.position = ConvertCoord.coord_to_vector(new_coord)


func get_x() -> int:
    return coord.x


func set_x(__: int) -> void:
    pass


func get_y() -> int:
    return coord.y


func set_y(__: int) -> void:
    pass
