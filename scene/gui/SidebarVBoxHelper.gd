extends Node2D
class_name Game_SidebarVBoxHelper


const ORDERED_DIRECTION := [
	Game_DirectionTag.LEFT,
	Game_DirectionTag.RIGHT,
	Game_DirectionTag.UP,
	Game_DirectionTag.DOWN,
]
const ORDERED_SUB_TAG := [
	Game_SubTag.RUM,
	Game_SubTag.PARROT,
	Game_SubTag.ACCORDION,
]

var _ref_PCState: Game_PCState

var _state_item: String
var _state_power: String


func get_state_item(force_update: bool) -> String:
	if force_update:
		_update_state()
	return _state_item


func get_state_power(force_update: bool) -> String:
	if force_update:
		_update_state()
	return _state_power


func _update_state() -> void:
	var mp := _ref_PCState.mp
	var max_mp := _ref_PCState.max_mp
	var mp_progress := _ref_PCState.mp_progress
	var mp_line := Game_SidebarText.MP % [mp, max_mp, mp_progress]

	var ghost := _get_ghost()
	var los := _get_line_of_sight()
	var sink := _get_sink()
	var state_line := Game_SidebarText.STATE % [ghost, los + sink]

	var inventory_line := _get_inventory()
	var power_line := _get_power()

	_state_item = Game_SidebarText.STATE_PANEL.format([
			Game_SidebarText.SEPARATOR,
			mp_line, state_line, inventory_line])
	_state_power = Game_SidebarText.STATE_PANEL.format([
			Game_SidebarText.SEPARATOR,
			mp_line, state_line, power_line])


func _get_ghost() -> String:
	if _ref_PCState.has_ghost:
		return Game_SidebarText.GHOST
	return ""


func _get_line_of_sight() -> String:
	var los := ""

	for i in ORDERED_DIRECTION:
		if _ref_PCState.is_in_npc_sight(i):
			los += " " + Game_SidebarText.DIRECTION_TO_CHAR[i]
	los = los.strip_edges()

	if los.length() > 0:
		return Game_SidebarText.LINE_OF_SIGHT % [los]
	return los


func _get_sink() -> String:
	var sink: int

	if _ref_PCState.sail_duration > 0:
		sink = Game_PCData.MAX_SAIL - _ref_PCState.sail_duration
		return Game_SidebarText.SINK % [sink]
	return ""


func _get_inventory() -> String:
	var items := []
	var sub_tag: String

	items.resize(ORDERED_SUB_TAG.size())
	for i in range(0, items.size()):
		sub_tag = ORDERED_SUB_TAG[i]
		if _ref_PCState.has_item(sub_tag):
			items[i] = Game_SidebarText.SUB_TAG_TO_ITEM[sub_tag]
		else:
			items[i] = ""
	return Game_SidebarText.INVENTORY % items


func _get_power() -> String:
	var full_text := ""
	var power_tag: int
	var power_direction: String
	var power_cost: int
	var power_name: String

	for i in ORDERED_DIRECTION:
		power_tag = _ref_PCState.get_power_tag(i)
		if power_tag == Game_PowerTag.NO_POWER:
			continue
		power_direction = Game_SidebarText.DIRECTION_TO_CHAR[i]
		power_cost = _ref_PCState.get_power_cost(i)
		power_name = Game_SidebarText.POWER_TAG_TO_NAME[power_tag]
		full_text += Game_SidebarText.POWER_TEMPLATE % [power_direction,
				power_cost, power_name]
	return full_text + Game_SidebarText.LAST_POWER
