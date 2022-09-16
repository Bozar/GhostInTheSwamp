extends StoreStateTemplate
class_name PcState


enum {
	SEAL_DICT,
	NPC_SIGHT,
	POWER_COST,
	POWER_TAG,
}

var mp := 0 setget set_mp, get_mp
var max_mp := PcData.MAX_MP
var mp_progress := 0 setget set_mp_progress, get_mp_progress
var has_ghost := false
var sail_duration := 0
var is_using_power := false

var _tag_to_state := {
	SubTag.RUM: false,
	SubTag.PARROT: false,
	SubTag.ACCORDION: false,
}
var _direction_to_state := {}
var _tag_to_arrow := {}


func _init(_basic_data: BasicSpriteData).(_basic_data)-> void:
	for i in DirectionTag.VALID_DIRECTIONS:
		_direction_to_state[i] = {
			NPC_SIGHT: false,
			POWER_COST: 0,
			POWER_TAG: PowerTag.NO_POWER,
		}


func set_coord(new_coord: IntCoord) -> void:
	.set_coord(new_coord)

	for i in _tag_to_arrow.keys():
		match i:
			SubTag.ARROW_RIGHT:
				_tag_to_arrow[i].position.y = _self_sprite.position.y
			SubTag.ARROW_DOWN:
				_tag_to_arrow[i].position.x = _self_sprite.position.x
			SubTag.ARROW_UP:
				_tag_to_arrow[i].position.x = _self_sprite.position.x


func set_tag_to_arrow(sub_tag: String, sprite: Sprite) -> void:
	if _tag_to_arrow.get(SEAL_DICT, false):
		return

	_tag_to_arrow[sub_tag] = sprite
	if _tag_to_arrow.size() == 3:
		_tag_to_arrow[SEAL_DICT] = true


func get_mp() -> int:
	return mp


# MP can be negative.
func set_mp(new_mp: int) -> void:
	mp = new_mp
	if mp > max_mp:
		mp = max_mp


func get_mp_progress() -> int:
	return mp_progress


# MP progress cannot be negative.
func set_mp_progress(new_progress: int) -> void:
	mp_progress = new_progress
	if mp_progress < 0:
		mp_progress = 0


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
