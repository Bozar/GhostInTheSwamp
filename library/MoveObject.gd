class_name MoveObject


static func move(sprite: Sprite, to_coord: IntCoord) -> void:
	DungeonBoard.remove_state(sprite)
	sprite.position = ConvertCoord.coord_to_vector(to_coord)
	DungeonBoard.add_sprite(sprite)
	_try_move_arrow(sprite)


static func _try_move_arrow(sprite: Sprite) -> void:
	if ObjectState.get_state(sprite).sub_tag != SubTag.PC:
		return
	for i in FindObject.get_sprites_with_tag(MainTag.INDICATOR):
		match ObjectState.get_state(i).sub_tag:
			SubTag.ARROW_RIGHT:
				i.position.y = sprite.position.y
			SubTag.ARROW_DOWN:
				i.position.x = sprite.position.x
			SubTag.ARROW_UP:
				i.position.x = sprite.position.x
