extends BasicSpriteData
class_name ActorState


func _init(_main_tag: String, _sub_tag: String).(_main_tag, _sub_tag) -> void:
	pass


var face_direction := DirectionTag.NO_DIRECTION setget set_face_direction, \
		get_face_direction
var show_arrow := false


func get_face_direction() -> int:
	return face_direction


func set_face_direction(direction_tag: int) -> void:
	if not direction_tag in DirectionTag.VALID_DIRECTIONS:
		face_direction = DirectionTag.NO_DIRECTION
	face_direction = direction_tag
