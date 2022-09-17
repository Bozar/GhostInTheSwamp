extends StateManagerTemplate
# class_name StateManager


# Order matters here. ObjectState should be added first and removed last.
func add_state(sprite_data: BasicSpriteData) -> void:
	ObjectState.add_state(sprite_data)
	DungeonBoard.add_state(sprite_data)


func remove_state(sprite: Sprite) -> void:
	DungeonBoard.remove_state(sprite)
	ObjectState.remove_state(sprite)


func remove_all() -> void:
	DungeonBoard.remove_all()
	ObjectState.remove_all()
