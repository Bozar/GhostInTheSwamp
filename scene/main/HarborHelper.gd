extends Node2D
class_name Game_HarborHelper


var _ref_DungeonBoard: Game_DungeonBoard
var _ref_ObjectState: Game_ObjectState


func toggle_harbor(coord: Game_IntCoord, is_active: bool) -> void:
	var harbor := _ref_DungeonBoard.get_building(coord)
	var new_sprite_type := Game_SpriteTypeTag.DEFAULT

	if is_active:
		new_sprite_type = Game_SpriteTypeTag.ACTIVE
	Game_SwitchSprite.set_sprite(harbor, new_sprite_type)
	_ref_ObjectState.set_harbor(harbor, is_active)
