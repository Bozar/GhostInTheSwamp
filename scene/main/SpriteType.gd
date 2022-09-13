extends Game_ObjectStateTemplate
class_name Game_SpriteType


func get_sprite_type(id: int) -> String:
	if not _id_to_state.has(id):
		_id_to_state[id] = Game_SpriteTypeTag.DEFAULT
	return _id_to_state[id]


func set_sprite_type(id: int, sprite_type: String) -> void:
	_id_to_state[id] = sprite_type
