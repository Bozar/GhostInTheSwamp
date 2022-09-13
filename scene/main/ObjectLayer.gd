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
	var id := sprite_data.sprite.get_instance_id()

	if sprite_data.sprite_layer != 0:
		set_layer(id, sprite_data.sprite_layer)
