extends Node2D
class_name GameSetting


signal setting_loaded(setting)
signal setting_saved(input_tag)

const WIZARD := "wizard_mode"
const SEED := "rng_seed"
const INCLUDE_WORLD := "include_world"
const EXCLUDE_WORLD := "exclude_world"
const SHOW_FULL_MAP := "show_full_map"
const PALETTE := "palette"
const MOUSE_INPUT := "mouse_input"

const SETTING_EXE_PATH := "data/setting.json"
const SETTING_RES_PATH := "res://bin/setting.json"

const PALETTE_EXE_PATH := "data/"
const PALETTE_RES_PATH := "res://bin/"
const JSON_EXTENSION := ".json"

const DEFAULT_EXCLUDE := [WorldTag.DEMO]

var _wizard_mode: bool
var _mouse_input: bool
var _rng_seed: int
var _include_world: Array
var _exclude_world: Array
var _show_full_map: bool
var _palette: Dictionary
var _json_parse_error: bool


func load_setting() -> void:
	var setting_data := {}
	var json_parser: FileParser

	# Load settings from setting.json.
	_json_parse_error = false
	for i in [SETTING_EXE_PATH, SETTING_RES_PATH]:
		if not FileIoHelper.has_file(i):
			continue
		json_parser = FileIoHelper.read_as_json(i)
		_json_parse_error = not json_parser.parse_success
		if json_parser.parse_success:
			setting_data = json_parser.output_json
			break

	# Set options for the current playthrough.
	_wizard_mode = _set_bool(setting_data, WIZARD)
	_mouse_input = _set_bool(setting_data, MOUSE_INPUT)
	_include_world = _set_array(setting_data, INCLUDE_WORLD)
	_exclude_world = _set_array(setting_data, EXCLUDE_WORLD, DEFAULT_EXCLUDE)
	_show_full_map = _set_bool(setting_data, SHOW_FULL_MAP)
	_rng_seed = _set_rng_seed(setting_data)
	_palette = _set_palette(setting_data)

	# Use settings from previous game if available. However, PALETTE is always
	# loaded from setting.json.
	if TransferData.is_initialized:
		_wizard_mode = TransferData.wizard_mode
		_mouse_input = TransferData.mouse_input
		_include_world = TransferData.include_world
		_exclude_world = TransferData.exclude_world
		_show_full_map = TransferData.show_full_map
		if TransferData.overwrite_rng_seed != 0:
			_rng_seed = TransferData.overwrite_rng_seed
			TransferData.overwrite_rng_seed = 0
		else:
			_rng_seed = TransferData.rng_seed
	else:
		TransferData.wizard_mode = _wizard_mode
		TransferData.mouse_input = _mouse_input
		TransferData.include_world = _include_world
		TransferData.exclude_world = _exclude_world
		TransferData.show_full_map = _show_full_map
		TransferData.rng_seed = _rng_seed
		TransferData.is_initialized = true

	emit_signal(SignalTag.SETTING_LOADED, self)


func save_setting(input_tag: String) -> void:
	emit_signal(SignalTag.SETTING_SAVED, input_tag)


func get_wizard_mode() -> bool:
	return _wizard_mode


func get_mouse_input() -> bool:
	return _mouse_input


func get_rng_seed() -> int:
	return _rng_seed


func get_include_world() -> Array:
	return _include_world


func get_exclude_world() -> Array:
	return _exclude_world


func get_show_full_map() -> bool:
	return _show_full_map


func get_palette() -> Dictionary:
	return _palette


func get_json_parse_error() -> bool:
	return _json_parse_error


func _set_rng_seed(setting: Dictionary) -> int:
	var random: int

	if setting.has(SEED) and (setting[SEED] is float):
		random = setting[SEED] as int
		return 0 if random < 1 else random
	return 0


func _set_array(setting: Dictionary, option: String, default_array := []) \
		-> Array:
	if setting.has(option) and (setting[option] is Array):
		return setting[option]
	return default_array


func _set_palette(setting: Dictionary) -> Dictionary:
	var file_name: String = ""
	var json_parser: FileParser

	if not (setting.has(PALETTE) and (setting[PALETTE] is String)):
		return {}

	file_name = setting[PALETTE]
	for i in [PALETTE_EXE_PATH, PALETTE_RES_PATH]:
		for j in ["", JSON_EXTENSION]:
			json_parser = FileIoHelper.read_as_json(i + file_name + j)
			if json_parser.parse_success:
				return json_parser.output_json
	return {}


func _set_bool(setting: Dictionary, option: String) -> bool:
	if setting.has(option):
		match typeof(setting[option]):
			TYPE_BOOL:
				return setting[option]
			TYPE_REAL:
				return setting[option] >= 1
	return false


func _on_RandomNumber_seed_updated(rng_seed: int) -> void:
	_rng_seed = rng_seed
