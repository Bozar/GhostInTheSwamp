extends Node2D
class_name Game_ObjectState


const OBJECT_LAYER := "ObjectLayer"
const SPRITE_TYPE := "SpriteType"
const BUILDING_STATE := "BuildingState"


func _on_CreateObject_sprite_created(sprite_data: Game_BasicSpriteData) -> void:
	for i in get_children():
		if i.has_method("create_object"):
			i.create_object(sprite_data)


func _on_RemoveObject_sprite_removed(sprite_data: Game_BasicSpriteData) -> void:
	for i in get_children():
		if i.has_method("remove_data"):
			i.remove_data(_get_id(sprite_data.sprite))


func get_layer(sprite: Sprite) -> int:
	return get_node(OBJECT_LAYER).get_layer(_get_id(sprite))


func set_layer(sprite: Sprite, layer: int) -> void:
	get_node(OBJECT_LAYER).set_layer(_get_id(sprite), layer)


func get_sprite_type(sprite: Sprite) -> String:
	return get_node(SPRITE_TYPE).get_sprite_type(_get_id(sprite))


func set_sprite_type(sprite: Sprite, sprite_type: String) -> void:
	get_node(SPRITE_TYPE).set_sprite_type(_get_id(sprite), sprite_type)


func harbor_is_active(sprite: Sprite) -> bool:
	return get_node(BUILDING_STATE).harbor_is_active(_get_id(sprite))


func set_harbor(sprite: Sprite, is_active: bool) -> void:
	get_node(BUILDING_STATE).set_harbor(_get_id(sprite), is_active)


func _get_id(sprite: Sprite) -> int:
	return sprite.get_instance_id()
