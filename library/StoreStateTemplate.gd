extends Node2D
class_name Game_StoreStateTemplate


var main_tag: String setget set_main_tag, get_main_tag
var sub_tag: String setget set_sub_tag, get_sub_tag
var coord: Game_IntCoord setget set_coord, get_coord
var x: int setget set_x, get_x
var y: int setget set_y, get_y

var _self_sprite: Sprite


func _init(basic_data: Game_BasicSpriteData) -> void:
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


func get_coord() -> Game_IntCoord:
    return Game_ConvertCoord.sprite_to_coord(_self_sprite)


func set_coord(new_coord: Game_IntCoord) -> void:
    _self_sprite.position = Game_ConvertCoord.coord_to_vector(new_coord)


func get_x() -> int:
    return coord.x


func set_x(new_x: int) -> void:
    set_xy(new_x, y)


func get_y() -> int:
    return coord.y


func set_y(new_y: int) -> void:
    set_xy(x, new_y)


func set_xy(new_x: int, new_y: int) -> void:
    _self_sprite.position = Game_ConvertCoord.xy_to_vector(new_x, new_y)
