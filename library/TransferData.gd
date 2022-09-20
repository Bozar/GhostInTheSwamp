extends Node
# class_name TransferData


var initialized := false setget _set_none, get_initialized
var json_parse_error := false setget _set_none, get_json_parse_error

var wizard_mode := false setget _set_none, get_wizard_mode
# Set rng_seed based on setting.json or debug_seed. Use rng_seed for actually
# game play. Refer: Setting, RandomNumber, SidebarVBox.
var rng_seed := 0 setget _set_none, get_rng_seed
# Set debug_seed in debug screen. Refer: DebugVBox.
var debug_seed := 0 setget _set_none, get_debug_seed
var palette_name := "" setget _set_none, get_palette_name
var show_full_map := false setget _set_none, get_show_full_map


func get_initialized() -> bool:
	return initialized


func set_initialized(new_data: bool) -> void:
	initialized = new_data


func get_wizard_mode() -> bool:
	return wizard_mode


func set_wizard_mode(new_data: bool) -> void:
	wizard_mode = new_data


func get_rng_seed() -> int:
	return rng_seed


func set_rng_seed(new_data: int) -> void:
	rng_seed = new_data


func get_debug_seed() -> int:
	return debug_seed


func set_debug_seed(new_data: int) -> void:
	debug_seed = new_data


func get_palette_name() -> String:
	return palette_name


func set_palette_name(new_data: String) -> void:
	palette_name = new_data


func get_show_full_map() -> bool:
	return show_full_map


func set_show_full_map(new_data: bool) -> void:
	show_full_map = new_data


func get_json_parse_error() -> bool:
	return json_parse_error


func set_json_parse_error(new_data: bool) -> void:
	json_parse_error = new_data


func _set_none(__) -> void:
	pass
