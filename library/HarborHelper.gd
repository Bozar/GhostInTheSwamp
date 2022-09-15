extends Node2D
class_name HarborHelper


var _ref_DungeonBoard: DungeonBoard

var _manage_state: ManageObjectState


func toggle_harbor(sprite: Sprite, is_active: bool) -> void:
	var new_sprite_type := SpriteTypeTag.DEFAULT
	var state: BuildingState = _manage_state.get_state(sprite)

	if is_active:
		new_sprite_type = SpriteTypeTag.ACTIVE
	SwitchSprite.set_sprite(sprite, new_sprite_type)
	state.is_active = is_active
