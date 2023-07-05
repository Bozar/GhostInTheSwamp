extends BasicSpriteData
class_name ActorState


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	return


var face_direction: int = DirectionTag.NO_DIRECTION setget set_face_direction
var show_sight := false
var detect_pc := false
var last_seen_pc_coord: IntCoord
var remove_self := false
var walk_path: Array


func set_face_direction(value: int) -> void:
	if not value in DirectionTag.VALID_DIRECTIONS:
		face_direction = DirectionTag.NO_DIRECTION
	face_direction = value


func reset_walk_path() -> void:
	walk_path.clear()
