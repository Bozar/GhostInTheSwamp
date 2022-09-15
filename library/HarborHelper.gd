extends Node2D
class_name Game_HarborHelper


var _ref_DungeonBoard: Game_DungeonBoard

var _manage_state: Game_ManageObjectState


func toggle_harbor(sprite: Sprite, is_active: bool) -> void:
	var new_sprite_type := Game_SpriteTypeTag.DEFAULT
	var state: Game_BuildingState = _manage_state.get_state(sprite)

	if is_active:
		new_sprite_type = Game_SpriteTypeTag.ACTIVE
	Game_SwitchSprite.set_sprite(sprite, new_sprite_type)
	state.is_active = is_active
