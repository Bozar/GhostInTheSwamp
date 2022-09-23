extends BasicSpriteData
class_name PcState


enum {
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
	TARGET_SPRITE,
}
const MAX_INT := 999

var _sub_tag_to_item := {
	SubTag.RUM: false,
	SubTag.PARROT: false,
	SubTag.ACCORDION: false,
}
var _direction_to_sight_power := {
	DirectionTag.UP: {},
	DirectionTag.DOWN: {},
	DirectionTag.LEFT: {},
	DirectionTag.RIGHT: {},
}

var mp := 0 setget set_mp, get_mp
var max_mp := PcData.MAX_MP setget _set_none, get_max_mp
var mp_progress := 0 setget set_mp_progress, get_mp_progress

# Increase the upper limit when collecting a new item.
var max_ghost := PcData.MAX_GHOST_PER_ITEM setget _set_none, get_max_ghost
# Add 1 after creating a ghost.
var count_ghost := 0 setget set_count_ghost, get_count_ghost

var has_ghost := false
# Spawn a ghost when the timer is below 1. Then reset it to its maximum.
var spawn_ghost_timer := PcData.MAX_GHOST_COUNTDOWN
var max_sail_duration := PcData.MAX_SAIL_DURATION  setget _set_none, \
		get_max_sail_duration
# Add 1 after moving in the swamp.
var sail_duration := 0 setget set_sail_duration, get_sail_duration

var use_power := false


func _init(_main_tag: String, _sub_tag: String).(_main_tag, _sub_tag) -> void:
	reset_direction_to_sight_power()


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


func get_max_ghost() -> int:
	return max_ghost


func _set_max_ghost() -> void:
	max_ghost = 0
	for i in _sub_tag_to_item.values():
		if i:
			max_ghost += PcData.MAX_GHOST_PER_ITEM


func set_sail_duration(new_data: int) -> void:
	sail_duration = _fix_overflow(new_data, max_sail_duration, 0)


func get_max_sail_duration() -> int:
	return max_sail_duration


func has_item(sub_tag: String) -> bool:
	return _sub_tag_to_item.get(sub_tag, false)


func add_item(sub_tag: String) -> void:
	# Add an item to inventory.
	if _sub_tag_to_item.has(sub_tag) and (not _sub_tag_to_item[sub_tag]):
		_sub_tag_to_item[sub_tag] = true
	else:
		return
	# Increase max_ghost.
	_set_max_ghost()
	# Rum increases max MP.
	if sub_tag == SubTag.RUM:
		max_mp = PcData.MAX_MP_WITH_RUM


func has_rum() -> bool:
	return has_item(SubTag.RUM)


func has_parrot() -> bool:
	return has_item(SubTag.PARROT)


func has_accordion() -> bool:
	return has_item(SubTag.ACCORDION)


func add_rum() -> void:
	add_item(SubTag.RUM)


func add_parrot() -> void:
	add_item(SubTag.PARROT)


func add_accordion() -> void:
	add_item(SubTag.ACCORDION)


func is_in_npc_sight(direction_tag: int) -> bool:
	return _direction_to_sight_power[direction_tag][NPC_SIGHT]


func set_npc_sight(direction_tag: int, is_in_sight: bool) -> void:
	_direction_to_sight_power[direction_tag][NPC_SIGHT] = is_in_sight


func get_power_cost(direction_tag: int) -> int:
	return _direction_to_sight_power[direction_tag][POWER_COST]


func set_power_cost(direction_tag: int, power_cost: int) -> void:
	_direction_to_sight_power[direction_tag][POWER_COST] = power_cost


func get_power_tag(direction_tag: int) -> int:
	return _direction_to_sight_power[direction_tag][POWER_TAG]


func set_power_tag(direction_tag: int, power_tag: int) -> void:
	_direction_to_sight_power[direction_tag][POWER_TAG] = power_tag


func get_target_sprite(direction_tag: int) -> Sprite:
	return _direction_to_sight_power[direction_tag][TARGET_SPRITE]


func set_target_sprite(direction_tag: int, sprite: Sprite) -> void:
	_direction_to_sight_power[direction_tag][TARGET_SPRITE] = sprite


func get_max_mp() -> int:
	return max_mp


func _fix_overflow(new_data: int, upper := MAX_INT, lower := -MAX_INT) -> int:
	return max(min(new_data, upper), lower) as int


func reset_direction_to_sight_power() -> void:
	for i in _direction_to_sight_power.keys():
		_direction_to_sight_power[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: PowerTag.NO_POWER,
			TARGET_SPRITE: null,
		}


func reset_sail_duration() -> void:
	sail_duration = 0


func _set_none(__) -> void:
	pass
