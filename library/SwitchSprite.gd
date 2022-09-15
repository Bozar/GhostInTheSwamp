extends Node2D
class_name SwitchSprite


const WARN_NO_SPRITE_TYPE := "Warn: [%s] not found."


static func set_sprite(sprite: Sprite, type_tag: String) -> void:
	if not sprite.has_node(type_tag):
		push_warning(WARN_NO_SPRITE_TYPE % [type_tag])
		return

	for i in sprite.get_children():
		if i.visible:
			i.visible = false
			break
	sprite.get_node(type_tag).visible = true


static func get_sprite(sprite: Sprite) -> String:
	for i in sprite.get_children():
		if i.visible:
			return i.name
	return SpriteTypeTag.DEFAULT
