class_name PackedSceneData


const ERR_NO_SCENE := "Error: Packed scene [{0}] not found."

const TAG_TO_SCENE := {
	# Indicator.
	SubTag.ARROW_UP: preload("res://sprite/TriangleUp.tscn"),
	SubTag.ARROW_DOWN: preload("res://sprite/TriangleDown.tscn"),
	SubTag.ARROW_RIGHT: preload("res://sprite/TriangleRight.tscn"),
	# Ground.
	SubTag.LAND: preload("res://sprite/Land.tscn"),
	SubTag.SWAMP: preload("res://sprite/Swamp.tscn"),
	# Trap.
	SubTag.RUM: preload("res://sprite/Rum.tscn"),
	SubTag.PARROT: preload("res://sprite/Parrot.tscn"),
	SubTag.ACCORDION: preload("res://sprite/Accordion.tscn"),
	# Building.
	SubTag.SHRUB: preload("res://sprite/Shrub.tscn"),
	SubTag.ISLAND: preload("res://sprite/Island.tscn"),
	SubTag.HARBOR: preload("res://sprite/Harbor.tscn"),
	SubTag.SHIP: preload("res://sprite/Ship.tscn"),
	SubTag.DINGHY: preload("res://sprite/Dinghy.tscn"),
	# Actor.
	SubTag.PC: preload("res://sprite/PC.tscn"),
	SubTag.TOURIST: preload("res://sprite/Tourist.tscn"),
	SubTag.SCOUT: preload("res://sprite/Scout.tscn"),
	SubTag.ENGINEER: preload("res://sprite/Engineer.tscn"),
	SubTag.PERFORMER: preload("res://sprite/Performer.tscn"),
}


static func get_packed_scene(sub_tag: String) -> PackedScene:
	if not TAG_TO_SCENE.has(sub_tag):
		push_error(ERR_NO_SCENE.format([sub_tag]))
		return null
	return TAG_TO_SCENE[sub_tag]
