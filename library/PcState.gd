extends BasicSpriteData
class_name PcState


enum {
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
}

const TAG_TO_STATE := {
	SubTag.RUM: false,
	SubTag.PARROT: false,
	SubTag.ACCORDION: false,
}

var mp := 0 setget set_mp, get_mp
var max_mp := PcData.MAX_MP
var mp_progress := 0 setget set_mp_progress, get_mp_progress
var has_ghost := false
var sail_duration := 0
var using_power := false

var _direction_to_state := {}


func _init(_main_tag: String, _sub_tag: String).(_main_tag, _sub_tag) -> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		_direction_to_state[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: PowerTag.NO_POWER,
		}


func get_mp() -> int:
	return mp


# MP can be negative.
func set_mp(new_data: int) -> void:
	mp = new_data
	if mp > max_mp:
		mp = max_mp


func get_mp_progress() -> int:
	return mp_progress


# MP progress cannot be negative.
func set_mp_progress(new_progress: int) -> void:
	mp_progress = new_progress
	if mp_progress < 0:
		mp_progress = 0
	while mp_progress >= PcData.MAX_MP_PROGRESS:
		mp_progress -= PcData.MAX_MP_PROGRESS
		set_mp(mp + 1)


func has_item(sub_tag: String) -> bool:
	if not TAG_TO_STATE.has(sub_tag):
		return false
	return TAG_TO_STATE[sub_tag]


func add_item(sub_tag: String) -> void:
	if TAG_TO_STATE.has(sub_tag):
		TAG_TO_STATE[sub_tag] = true


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
