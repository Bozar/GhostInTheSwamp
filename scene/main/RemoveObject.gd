extends Node2D
class_name RemoveObject


signal sprite_removed(sprite_data)


func remove(main_tag: String, coord: IntCoord) -> void:
	var remove_this: Sprite = $FindObject.get_sprite(main_tag, coord)
	if remove_this == null:
		return

	emit_signal(SignalTag.SPRITE_REMOVED, BasicSpriteData.new(remove_this,
			main_tag, SubTag.REMOVE_SPRITE, coord))
	ObjectState.remove_state(remove_this)
	remove_this.queue_free()


func remove_actor(coord: IntCoord) -> void:
	remove(MainTag.ACTOR, coord)


func remove_building(coord: IntCoord) -> void:
	remove(MainTag.BUILDING, coord)


func remove_trap(coord: IntCoord) -> void:
	remove(MainTag.TRAP, coord)


func remove_ground(coord: IntCoord) -> void:
	remove(MainTag.GROUND, coord)
