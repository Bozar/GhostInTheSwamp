extends Node2D
class_name RemoveObject


signal sprite_removed(remove_sprite)


func remove(remove_this: Sprite) -> void:
	if remove_this == null:
		return

	emit_signal(SignalTag.SPRITE_REMOVED, remove_this)
	StateManager.remove_state(remove_this)
	remove_this.queue_free()


func remove_by_coord(main_tag: String, coord: IntCoord) -> void:
	remove(FindObject.get_sprite(main_tag, coord))


func remove_actor(coord: IntCoord) -> void:
	remove_by_coord(MainTag.ACTOR, coord)


func remove_building(coord: IntCoord) -> void:
	remove_by_coord(MainTag.BUILDING, coord)


func remove_trap(coord: IntCoord) -> void:
	remove_by_coord(MainTag.TRAP, coord)


func remove_ground(coord: IntCoord) -> void:
	remove_by_coord(MainTag.GROUND, coord)
