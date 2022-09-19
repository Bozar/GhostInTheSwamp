extends BasicSpriteData
class_name PcState


enum {
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
}
const MAX_INT := 999

const TAG_TO_STATE := {
	SubTag.RUM: false,
	SubTag.PARROT: false,
	SubTag.ACCORDION: false,
}
const DIRECTION_TO_STATE := {
	DirectionTag.UP: {},
	DirectionTag.DOWN: {},
	DirectionTag.LEFT: {},
	DirectionTag.RIGHT: {},
}

var mp := 0 setget set_mp, get_mp
var max_mp := PcData.MAX_MP
var mp_progress := 0 setget set_mp_progress, get_mp_progress

# Increase the upper limit when collecting a new item.
var max_ghost := PcData.MAX_GHOST_PER_ITEM
# Add 1 after removing a ghost due to any reason.
var count_ghost := 0 setget set_count_ghost, get_count_ghost

var has_ghost := false
var max_sail_duration := PcData.MAX_SAIL_DURATION
# Add 1 after moving in the water for 1 turn.
var sail_duration := 0 setget set_sail_duration, get_sail_duration

var use_power := false


func _init(_main_tag: String, _sub_tag: String).(_main_tag, _sub_tag) -> void:
	for i in DIRECTION_TO_STATE.keys():
		DIRECTION_TO_STATE[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: PowerTag.NO_POWER,
		}


func get_mp() -> int:
	return mp


# MP can be negative.
func set_mp(new_data: int) -> void:
	mp = _fix_overflow(new_data, max_mp)


func get_mp_progress() -> int:
	return mp_progress


# MP progress cannot be negative.
func set_mp_progress(new_data: int) -> void:
	mp_progress = _fix_overflow(new_data, MAX_INT, 0)
	while mp_progress >= PcData.MAX_MP_PROGRESS:
		mp_progress -= PcData.MAX_MP_PROGRESS
		set_mp(mp + 1)


func get_count_ghost() -> int:
	return count_ghost


func set_count_ghost(new_data: int) -> void:
	count_ghost = _fix_overflow(new_data, max_ghost, 0)


func get_sail_duration() -> int:
	return sail_duration


func set_sail_duration(new_data: int) -> void:
	sail_duration = _fix_overflow(new_data, max_sail_duration, 0)


func has_item(sub_tag: String) -> bool:
	if not TAG_TO_STATE.has(sub_tag):
		return false
	return TAG_TO_STATE[sub_tag]


func add_item(sub_tag: String) -> void:
	if TAG_TO_STATE.has(sub_tag):
		TAG_TO_STATE[sub_tag] = true


func is_in_npc_sight(direction_tag: int) -> bool:
	return DIRECTION_TO_STATE[direction_tag][NPC_SIGHT]


func set_npc_sight(direction_tag: int, is_in_sight: bool) -> void:
	DIRECTION_TO_STATE[direction_tag][NPC_SIGHT] = is_in_sight


func get_power_cost(direction_tag: int) -> int:
	return DIRECTION_TO_STATE[direction_tag][POWER_COST]


func set_power_cost(direction_tag: int, power_cost: int) -> void:
	DIRECTION_TO_STATE[direction_tag][POWER_COST] = power_cost


func get_power_tag(direction_tag: int) -> int:
	return DIRECTION_TO_STATE[direction_tag][POWER_TAG]


func set_power_tag(direction_tag: int, power_tag: int) -> void:
	DIRECTION_TO_STATE[direction_tag][POWER_TAG] = power_tag


func _fix_overflow(new_data: int, upper := MAX_INT, lower := -MAX_INT) -> int:
	return max(min(new_data, upper), lower) as int
