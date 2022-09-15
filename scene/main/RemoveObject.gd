extends Node2D
class_name RemoveObject


signal sprite_removed(sprite_data)

var _ref_DungeonBoard: DungeonBoard


func remove_xy(main_tag: String, x: int, y: int) -> void:
	var remove_this := _ref_DungeonBoard.get_sprite_xy(main_tag, x, y)
	if remove_this == null:
		return

	emit_signal(SignalTag.SPRITE_REMOVED, BasicSpriteData.new(remove_this,
			main_tag, SubTag.REMOVE_SPRITE, x, y))
	ObjectState.remove_state(remove_this)
	remove_this.queue_free()


func remove(main_tag: String, coord: IntCoord) -> void:
	remove_xy(main_tag, coord.x, coord.y)


func remove_actor_xy(x: int, y: int) -> void:
	remove_xy(MainTag.ACTOR, x, y)


func remove_actor(coord: IntCoord) -> void:
	remove_actor_xy(coord.x, coord.y)


func remove_building_xy(x: int, y: int) -> void:
	remove_xy(MainTag.BUILDING, x, y)


func remove_building(coord: IntCoord) -> void:
	remove_building_xy(coord.x, coord.y)


func remove_trap_xy(x: int, y: int) -> void:
	remove_xy(MainTag.TRAP, x, y)


func remove_trap(coord: IntCoord) -> void:
	remove_trap_xy(coord.x, coord.y)


func remove_ground_xy(x: int, y: int) -> void:
	remove_xy(MainTag.GROUND, x, y)


func remove_ground(coord: IntCoord) -> void:
	remove_ground_xy(coord.x, coord.y)
