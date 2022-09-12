extends Node2D
class_name Game_SwitchSprite


const WARN_NO_SPRITE_TYPE := "Warn: [{0}] not found."

var _ref_ObjectData: Game_ObjectData


func set_sprite(sprite: Sprite, type_tag: String) -> void:
	var current_type: String

	if not sprite.has_node(type_tag):
		push_warning(WARN_NO_SPRITE_TYPE.format([type_tag]))
		return

	current_type = _ref_ObjectData.get_sprite_type(sprite)

	sprite.get_node(current_type).visible = false
	sprite.get_node(type_tag).visible = true

	current_type = type_tag
	_ref_ObjectData.set_sprite_type(sprite, current_type)
