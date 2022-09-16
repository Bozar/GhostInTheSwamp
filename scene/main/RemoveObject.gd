extends Node2D
class_name RemoveObject


signal sprite_removed(sprite_data)


func remove(remove_this: Sprite) -> void:
	var store_state: StoreStateTemplate

	if remove_this == null:
		return
	store_state = ObjectState.get_state(remove_this)
	_free_sprite(remove_this, store_state.main_tag, store_state.coord)


func remove_by_coord(main_tag: String, coord: IntCoord) -> void:
	var remove_this: Sprite = $FindObject.get_sprite(main_tag, coord)

	if remove_this == null:
		return
	_free_sprite(remove_this, main_tag, coord)


func remove_actor(coord: IntCoord) -> void:
	remove_by_coord(MainTag.ACTOR, coord)


func remove_building(coord: IntCoord) -> void:
	remove_by_coord(MainTag.BUILDING, coord)


func remove_trap(coord: IntCoord) -> void:
	remove_by_coord(MainTag.TRAP, coord)


func remove_ground(coord: IntCoord) -> void:
	remove_by_coord(MainTag.GROUND, coord)


func _free_sprite(sprite: Sprite, main_tag: String, coord: IntCoord) -> void:
	emit_signal(SignalTag.SPRITE_REMOVED, BasicSpriteData.new(sprite, main_tag,
			SubTag.REMOVE_SPRITE, coord))
	ObjectState.remove_state(sprite)
	sprite.queue_free()
