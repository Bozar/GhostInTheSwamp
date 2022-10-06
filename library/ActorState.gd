extends BasicSpriteData
class_name ActorState


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	return


var face_direction := DirectionTag.NO_DIRECTION setget set_face_direction, \
		get_face_direction
var show_sight := false
var detect_pc := false
var last_seen_pc_coord: IntCoord
var remove_self := false
var walk_path: Array


func get_face_direction() -> int:
	return face_direction


func set_face_direction(direction_tag: int) -> void:
	if not direction_tag in DirectionTag.VALID_DIRECTIONS:
		face_direction = DirectionTag.NO_DIRECTION
	face_direction = direction_tag


func reset_walk_path() -> void:
	walk_path.clear()
