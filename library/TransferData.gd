extends Node2D
# class_name TransferData
# =====Autoload=====


var initialized: bool setget _set_none, get_initialized
var json_parse_error: bool setget _set_none, get_json_parse_error

var wizard_mode: bool setget _set_none, get_wizard_mode
# Set rng_seed based on setting.json or debug_seed. Use rng_seed for actual game
# play. Refer: Setting, RandomNumber, SidebarVBox.
var rng_seed: int setget _set_none, get_rng_seed
# Set debug_seed in debug screen. Refer: DebugVBox.
var debug_seed: int setget _set_none, get_debug_seed
var palette_name: String setget _set_none, get_palette_name
var show_full_map: bool setget _set_none, get_show_full_map

var _initialized := false
var _json_parse_error := false
var _wizard_mode := false
var _rng_seed: int = 0
var _debug_seed: int = 0
var _palette_name := ""
var _show_full_map := false


func set_initialized(value: bool) -> void:
	_initialized = value


func get_initialized() -> bool:
	return _initialized


func set_json_parse_error(value: bool) -> void:
	_json_parse_error = value


func get_json_parse_error() -> bool:
	return _json_parse_error


func set_wizard_mode(value: bool) -> void:
	_wizard_mode = value


func get_wizard_mode() -> bool:
	return _wizard_mode


func get_rng_seed() -> int:
	return _rng_seed


func set_rng_seed(value: int) -> void:
	_rng_seed = value


func get_debug_seed() -> int:
	return _debug_seed


func set_debug_seed(value: int) -> void:
	_debug_seed = value


func get_palette_name() -> String:
	return _palette_name


func set_palette_name(value: String) -> void:
	_palette_name = value


func get_show_full_map() -> bool:
	return _show_full_map


func set_show_full_map(value: bool) -> void:
	_show_full_map = value


func _set_none(_value) -> void:
	return
