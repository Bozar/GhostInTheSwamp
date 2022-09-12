extends Node2D
class_name Game_ObjectData


const OBJECT_LAYER := "ObjectLayer"
const SPRITE_TYPE := "SpriteType"


func _on_CreateObject_sprite_created(sprite_data: Game_BasicSpriteData) -> void:
	if sprite_data.sprite_layer != 0:
		set_layer(sprite_data.sprite, sprite_data.sprite_layer)


func _on_RemoveObject_sprite_removed(sprite_data: Game_BasicSpriteData) -> void:
	var child_node: Array = get_children()
	for i in child_node:
		i.remove_data(_get_id(sprite_data.sprite))


func get_layer(sprite: Sprite) -> int:
	return get_node(OBJECT_LAYER).get_layer(_get_id(sprite))


func set_layer(sprite: Sprite, layer: int) -> void:
	get_node(OBJECT_LAYER).set_layer(_get_id(sprite), layer)


func get_sprite_type(sprite: Sprite) -> String:
	return get_node(SPRITE_TYPE).get_sprite_type(_get_id(sprite))


func set_sprite_type(sprite: Sprite, sprite_type: String) -> void:
	get_node(SPRITE_TYPE).set_sprite_type(_get_id(sprite), sprite_type)


func _get_id(sprite: Sprite) -> int:
	return sprite.get_instance_id()
