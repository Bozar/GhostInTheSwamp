extends BasicSpriteData
class_name HarborState


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	is_active = false
	is_locked = false


var is_active: bool
var is_locked: bool
