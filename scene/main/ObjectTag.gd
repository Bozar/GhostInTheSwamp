extends Game_ObjectStateTemplate
class_name Game_ObjectTag


func get_main_tag(id: int) -> String:
	return _id_to_state[id][0]


func get_sub_tag(id: int) -> String:
	return _id_to_state[id][1]


func create_object(sprite_data: Game_BasicSpriteData) -> void:
	_set_tag(sprite_data)


func _set_tag(sprite_data: Game_BasicSpriteData) -> void:
	var id: int = get_parent()._get_id(sprite_data.sprite)
	var main_tag := sprite_data.main_tag
	var sub_tag := sprite_data.sub_tag

	_id_to_state[id] = [main_tag, sub_tag]
