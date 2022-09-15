extends Node2D
class_name Game_ManageObjectState


const SUB_TAG_TO_STATE := {
	Game_SubTag.PC: Game_PcState,
}
const MAIN_TAG_TO_STATE := {
	Game_MainTag.BUILDING: Game_BuildingState,
}

var _child_node := preload("res://library/ObjectState.tscn")


func add_state_node(sprite_data: Game_BasicSpriteData) -> void:
	var this_sprite := sprite_data.sprite
	var main_tag := sprite_data.main_tag
	var sub_tag := sprite_data.sub_tag
	var this_child: Game_ObjectState

	if this_sprite.has_node(Game_NodeTag.OBJECT_STATE):
		return
	this_sprite.add_child(_child_node.instance())
	this_child = this_sprite.get_node(Game_NodeTag.OBJECT_STATE)

	if SUB_TAG_TO_STATE.has(sub_tag):
		this_child.store_state = SUB_TAG_TO_STATE[sub_tag].new(sprite_data)
	elif MAIN_TAG_TO_STATE.has(main_tag):
		this_child.store_state = MAIN_TAG_TO_STATE[main_tag].new(sprite_data)


func get_state(sprite: Sprite) -> Game_StoreStateTemplate:
	if sprite.has_node(Game_NodeTag.OBJECT_STATE):
		return sprite.get_node(Game_NodeTag.OBJECT_STATE).store_state
	return null
