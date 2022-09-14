extends Node2D
class_name Game_PcState


enum {
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
}

var mp := 0
var max_mp := Game_PcData.MAX_MP
var mp_progress := 0
var has_ghost := false
var sail_duration := 0
var is_using_power := false

var _tag_to_state := {
	Game_SubTag.RUM: false,
	Game_SubTag.PARROT: false,
	Game_SubTag.ACCORDION: false,
}
var _direction_to_state := {}


func _ready() -> void:
	for i in Game_DirectionTag.VALID_DIRECTIONS:
		_direction_to_state[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: Game_PowerTag.NO_POWER,
		}


func has_item(sub_tag: String) -> bool:
	if not _tag_to_state.has(sub_tag):
		return false
	return _tag_to_state[sub_tag]


func add_item(sub_tag: String) -> void:
	if _tag_to_state.has(sub_tag):
		_tag_to_state[sub_tag] = true


func is_in_npc_sight(direction_tag: int) -> bool:
	return _direction_to_state[direction_tag][NPC_SIGHT]


func set_npc_sight(direction_tag: int, is_in_sight: bool) -> void:
	_direction_to_state[direction_tag][NPC_SIGHT] = is_in_sight


func get_power_cost(direction_tag: int) -> int:
	return _direction_to_state[direction_tag][POWER_COST]


func set_power_cost(direction_tag: int, power_cost: int) -> void:
	_direction_to_state[direction_tag][POWER_COST] = power_cost


func get_power_tag(direction_tag: int) -> int:
	return _direction_to_state[direction_tag][POWER_TAG]


func set_power_tag(direction_tag: int, power_tag: int) -> void:
	_direction_to_state[direction_tag][POWER_TAG] = power_tag
