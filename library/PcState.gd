extends BasicSpriteData
class_name PcState


const ERR_TRAP_SUB_TAG := "%s is not a trap sub tag."

enum {
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
	TARGET_SPRITE,
}
const MAX_INT: int = 999

var mp: int setget _set_mp, _get_mp
var max_mp: int setget _set_none, _get_max_mp
var mp_progress: int setget _set_mp_progress, _get_mp_progress
var actor_collision: int setget _set_actor_collision, _get_actor_collision

# Increase the upper limit when collecting a new item.
var max_ghost: int setget _set_none, _get_max_ghost
# Add 1 after creating a ghost.
var count_ghost: int setget _set_count_ghost, _get_count_ghost

var has_ghost := true
# Spawn a ghost when the timer is below 1. Then reset it to its maximum.
var spawn_ghost_timer: int = 0
# Add 1 after moving in the swamp.
var sail_duration: int setget _set_sail_duration, _get_sail_duration
var use_pirate_ship := false

var use_power := false
var show_sight := false
var count_item: int setget _set_none, _get_count_item
var inactive_counter: int setget _set_inactive_counter, _get_inactive_counter

var _mp: int = PcData.MAX_MP
var _max_mp: int = PcData.MAX_MP
var _mp_progress: int = 0
var _actor_collision: int = 0
var _max_ghost: int = PcData.ITEM_TO_MAX_GHOST[0]
var _count_ghost: int = 0
var _sail_duration: int = 0
var _count_item: int = 0
var _inactive_counter: int = 0

var _sub_tag_to_item := {
	SubTag.RUM: false,
	SubTag.PARROT: false,
	SubTag.ACCORDION: false,
}
var _drop_score := {
	SubTag.RUM: 0,
	SubTag.PARROT: 0,
	SubTag.ACCORDION: 0,
}
# DirectionTag.UP: {
# 	NPC_SIGHT: false,
# 	POWER_COST: 0,
# 	POWER_TAG: PowerTag.NO_POWER,
# 	TARGET_SPRITE: null,
# }
var _direction_to_sight_power := {
	DirectionTag.UP: {},
	DirectionTag.DOWN: {},
	DirectionTag.LEFT: {},
	DirectionTag.RIGHT: {},
}
var _direction_to_movement := {
	DirectionTag.UP: false,
	DirectionTag.DOWN: false,
	DirectionTag.LEFT: false,
	DirectionTag.RIGHT: false,
}


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	_init_direction_to_sight_power()


func has_item(sub_tag: String) -> bool:
	return _sub_tag_to_item.get(sub_tag, false)


func add_item(sub_tag: String) -> void:
	# Add an item to inventory.
	if _sub_tag_to_item.has(sub_tag) and (not _sub_tag_to_item[sub_tag]):
		_sub_tag_to_item[sub_tag] = true
		_count_item += 1
	else:
		return
	# Increase max_ghost.
	_max_ghost = PcData.ITEM_TO_MAX_GHOST[_get_count_item()]
	# Rum increases max MP.
	if sub_tag == SubTag.RUM:
		_max_mp = PcData.MAX_MP_WITH_RUM


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


func get_direction_to_movement(direction_tag: int) -> bool:
	return _direction_to_movement.get(direction_tag, false)


func set_direction_to_movement(direction_tag: int, can_move: bool) -> void:
	_direction_to_movement[direction_tag] = can_move


func get_drop_score(sub_tag: String) -> int:
	if not _drop_score.has(sub_tag):
		push_error(ERR_TRAP_SUB_TAG % sub_tag)
		return 0
	return _drop_score[sub_tag]


func add_drop_score(sub_tag: String, value: int) -> void:
	if not _drop_score.has(sub_tag):
		push_error(ERR_TRAP_SUB_TAG % sub_tag)
		return

	_drop_score[sub_tag] += value
	if _drop_score[sub_tag] < 0:
		_drop_score[sub_tag] = 0


func add_all_drop_scores(value: int) -> void:
	for i in _drop_score.keys():
		add_drop_score(i, value)


func get_hit(sub_tag: String) -> int:
	if not _drop_score.has(sub_tag):
		push_error(ERR_TRAP_SUB_TAG % sub_tag)
		return 0
	return get_drop_score(sub_tag) / PcData.LOW_DROP_SCORE


func reset_direction_to_sight_power() -> void:
	for i in _direction_to_sight_power.keys():
		_direction_to_sight_power[i][NPC_SIGHT] = false
		_direction_to_sight_power[i][POWER_COST] = 0
		_direction_to_sight_power[i][POWER_TAG] = PowerTag.NO_POWER
		_direction_to_sight_power[i][TARGET_SPRITE] = null


func is_inactive() -> bool:
	return _inactive_counter == PcData.MAX_INACTIVE_COUNTER


# MP can be negative.
func _set_mp(value: int) -> void:
	_mp = _fix_overflow(value, _get_max_mp(), PcData.MIN_MP)


func _get_mp() -> int:
	return _mp


func _get_max_mp() -> int:
	return _max_mp


# MP progress cannot be negative.
func _set_mp_progress(value: int) -> void:
	_mp_progress = _fix_overflow(value, MAX_INT, 0)
	while _get_mp_progress() >= PcData.MAX_MP_PROGRESS:
		_mp_progress -= PcData.MAX_MP_PROGRESS
		_set_mp(_get_mp() + 1)


func _get_mp_progress() -> int:
	return _mp_progress


func _set_actor_collision(value: int) -> void:
	_actor_collision = _fix_overflow(value, PcData.MAX_ACTOR_COLLISION, 0)


func _get_actor_collision() -> int:
	return _actor_collision


func _get_max_ghost() -> int:
	return _max_ghost


func _set_count_ghost(value: int) -> void:
	_count_ghost = _fix_overflow(value, _get_max_ghost(), 0)


func _get_count_ghost() -> int:
	return _count_ghost


func _set_sail_duration(value: int) -> void:
	_sail_duration = _fix_overflow(value, PcData.MAX_SAIL_DURATION, 0)


func _get_sail_duration() -> int:
	return _sail_duration


func _get_count_item() -> int:
	return _count_item


func _set_inactive_counter(value: int) -> void:
	if value < 0:
		_inactive_counter = 0
	elif value > PcData.MAX_INACTIVE_COUNTER:
		_set_actor_collision(_get_actor_collision() + 1)
		_inactive_counter = 0
	else:
		_inactive_counter = value


func _get_inactive_counter() -> int:
	return _inactive_counter


func _fix_overflow(value: int, upper: int, lower: int) -> int:
	return max(min(value, upper), lower) as int


func _init_direction_to_sight_power() -> void:
	for i in _direction_to_sight_power.keys():
		_direction_to_sight_power[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: PowerTag.NO_POWER,
			TARGET_SPRITE: null,
		}


func _set_none(_value) -> void:
	return
