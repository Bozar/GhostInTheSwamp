extends Node2D
class_name Game_HarborHelper


func toggle_harbor(coord: Game_IntCoord, is_active: bool) -> void:
	var harbor: Sprite = get_parent()._ref_DungeonBoard.get_building(coord)
	var new_sprite_type := Game_SpriteTypeTag.DEFAULT

	if is_active:
		new_sprite_type = Game_SpriteTypeTag.ACTIVE
	get_parent()._ref_SwitchSprite.set_sprite(harbor, new_sprite_type)
	get_parent()._ref_ObjectData.set_harbor(harbor, is_active)
