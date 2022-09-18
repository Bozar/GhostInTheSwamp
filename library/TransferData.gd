extends Node
# class_name TransferData


var initialized := false setget _set_none, get_initialized

var wizard_mode := false setget _set_none, get_wizard_mode
# Set overwrite_rng_seed in RandomNumber.
var overwrite_rng_seed := 0 setget _set_none, get_overwrite_rng_seed
# Set rng_seed in DebugVBox.
var rng_seed := 0 setget _set_none, get_rng_seed
var show_full_map := false setget _set_none, get_show_full_map

var include_world: Array
var exclude_world: Array
var mouse_input: bool


func get_initialized() -> bool:
	return initialized


func set_initialized(new_data: bool, node: Node) -> void:
	if _is_valid_group(node):
		initialized = new_data


func get_wizard_mode() -> bool:
	return wizard_mode


func set_wizard_mode(new_data: bool, node: Node) -> void:
	if _is_valid_group(node):
		wizard_mode = new_data


func get_overwrite_rng_seed() -> int:
	return overwrite_rng_seed


func set_overwrite_rng_seed(new_data: int, node: Node) -> void:
	if _is_valid_group(node):
		overwrite_rng_seed = new_data


func get_rng_seed() -> int:
	return rng_seed


func set_rng_seed(new_data: int, node: Node) -> void:
	if _is_valid_group(node):
		rng_seed = new_data


func get_show_full_map() -> bool:
	return show_full_map


func set_show_full_map(new_data: bool, node: Node) -> void:
	if _is_valid_group(node):
		show_full_map = new_data


func _set_none(__) -> void:
	pass


func _is_valid_group(node: Node) -> bool:
	return node.is_in_group(MainTag.GAME_SETTING)
