extends Game_ObjectStateTemplate
class_name Game_ObjectLayer
# When two sprites of the same main tag appears at the same position, put them
# into different layers. Refer to InitBaron.gd.


func get_layer(id: int) -> int:
	if not _id_to_state.has(id):
		_id_to_state[id] = 0
	return _id_to_state[id]


func set_layer(id: int, layer: int) -> void:
	_id_to_state[id] = layer


func create_object(sprite_data: Game_BasicSpriteData) -> void:
	if sprite_data.sprite_layer != 0:
		get_parent().set_layer(sprite_data.sprite, sprite_data.sprite_layer)
