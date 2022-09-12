class_name Game_PackedSceneData


const ERR_NO_SCENE := "Error: Packed scene [{0}] not found."

const TAG_TO_SCENE := {
	# Indicator.
	Game_SubTag.ARROW_UP: preload("res://sprite/TriangleUp.tscn"),
	Game_SubTag.ARROW_DOWN: preload("res://sprite/TriangleDown.tscn"),
	Game_SubTag.ARROW_RIGHT: preload("res://sprite/TriangleRight.tscn"),
	# Ground.
	Game_SubTag.LAND: preload("res://sprite/Land.tscn"),
	# Trap.
	# Building.
	Game_SubTag.SHRUB: preload("res://sprite/Shrub.tscn"),
	# Actor.
	Game_SubTag.PC: preload("res://sprite/PC.tscn"),
}


static func get_packed_scene(sub_tag: String) -> PackedScene:
	if not TAG_TO_SCENE.has(sub_tag):
		push_error(ERR_NO_SCENE.format([sub_tag]))
		return null
	return TAG_TO_SCENE[sub_tag]
