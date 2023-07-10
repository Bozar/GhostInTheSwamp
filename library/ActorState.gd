extends BasicSpriteData
class_name ActorState


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	return


var face_direction: int setget _set_face_direction, _get_face_direction
var detect_pc := false
var last_seen_pc_coord: IntCoord
var remove_self := false
var walk_path: Array

var _face_direction: int = DirectionTag.NO_DIRECTION


func _set_face_direction(value: int) -> void:
	if value in DirectionTag.VALID_DIRECTIONS:
		_face_direction = value
	else:
		_face_direction = DirectionTag.NO_DIRECTION


func _get_face_direction() -> int:
	return _face_direction


func reset_walk_path() -> void:
	walk_path.clear()
