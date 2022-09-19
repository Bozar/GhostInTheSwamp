extends Node2D
class_name SidebarVBoxHelper


const ORDERED_DIRECTION := [
	DirectionTag.LEFT,
	DirectionTag.RIGHT,
	DirectionTag.UP,
	DirectionTag.DOWN,
]
const ORDERED_SUB_TAG := [
	SubTag.RUM,
	SubTag.PARROT,
	SubTag.ACCORDION,
]

var _pc_state: PcState

var _state_item: String
var _state_power: String


func set_reference() -> void:
	_pc_state = ObjectState.get_state(FindObject.pc)


func get_state_item(force_update := true) -> String:
	if force_update:
		_update_state()
	return _state_item


func get_state_power() -> String:
	return _state_power


func _update_state() -> void:
	var mp := _pc_state.mp
	var max_mp := _pc_state.max_mp
	var mp_progress := _pc_state.mp_progress
	var mp_line := SidebarText.MP % [mp, max_mp, mp_progress]

	var ghost := _get_ghost()
	var los := _get_line_of_sight()
	var sink := _get_sink()
	var state_line := SidebarText.STATE % [ghost, los + sink]

	var inventory_line := _get_inventory()
	var power_line := _get_power()

	_state_item = SidebarText.STATE_PANEL.format([
			SidebarText.SEPARATOR,
			mp_line, state_line, inventory_line])
	_state_power = SidebarText.STATE_PANEL.format([
			SidebarText.SEPARATOR,
			mp_line, state_line, power_line])


func _get_ghost() -> String:
	if _pc_state.has_ghost:
		return SidebarText.GHOST
	return ""


func _get_line_of_sight() -> String:
	var los := ""

	for i in ORDERED_DIRECTION:
		if _pc_state.is_in_npc_sight(i):
			los += " " + SidebarText.DIRECTION_TO_CHAR[i]
	los = los.strip_edges()

	if los.length() > 0:
		return SidebarText.LINE_OF_SIGHT % [los]
	return los


func _get_sink() -> String:
	var sink: int

	if _pc_state.sail_duration > 0:
		sink = PcData.MAX_SAIL - _pc_state.sail_duration
		return SidebarText.SINK % [sink]
	return ""


func _get_inventory() -> String:
	var items := []
	var sub_tag: String

	items.resize(ORDERED_SUB_TAG.size())
	for i in range(0, items.size()):
		sub_tag = ORDERED_SUB_TAG[i]
		if _pc_state.has_item(sub_tag):
			items[i] = SidebarText.SUB_TAG_TO_ITEM[sub_tag]
		else:
			items[i] = ""
	return SidebarText.INVENTORY % items


func _get_power() -> String:
	var full_text := ""
	var power_tag: int
	var power_direction: String
	var power_cost: int
	var power_name: String

	for i in ORDERED_DIRECTION:
		power_tag = _pc_state.get_power_tag(i)
		if power_tag == PowerTag.NO_POWER:
			continue
		power_direction = SidebarText.DIRECTION_TO_CHAR[i]
		power_cost = _pc_state.get_power_cost(i)
		power_name = SidebarText.POWER_TAG_TO_NAME[power_tag]
		full_text += SidebarText.POWER_TEMPLATE % [power_direction,
				power_cost, power_name]
	return full_text + SidebarText.LAST_POWER
