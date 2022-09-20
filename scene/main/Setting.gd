extends Node2D
class_name Setting


signal setting_loaded()
signal setting_saved(input_tag)

const WIZARD := "wizard_mode"
const SEED := "rng_seed"
const SHOW_FULL_MAP := "show_full_map"
const PALETTE := "palette"

const SETTING_EXE_PATH := "data/setting.json"
const SETTING_RES_PATH := "res://bin/setting.json"

var _ref_RandomNumber: RandomNumber


func load_setting() -> void:
	var wizard_mode := false
	var rng_seed := 0
	var show_full_map := false
	var palette_name := ""
	var json_parse_error := false
	var setting_data := {}
	var json_parser: FileParser

	# Try to parse setting.json.
	for i in [SETTING_EXE_PATH, SETTING_RES_PATH]:
		if not FileIoHelper.has_file(i):
			continue
		json_parser = FileIoHelper.read_as_json(i)
		json_parse_error = not json_parser.parse_success
		if json_parser.parse_success:
			setting_data = json_parser.output_json
			break

	# Load settings from setting.json.
	TransferData.set_json_parse_error(json_parse_error)
	wizard_mode = _get_bool(setting_data, WIZARD)
	show_full_map = _get_bool(setting_data, SHOW_FULL_MAP)
	rng_seed = _get_rng_seed(setting_data)
	palette_name = _get_palette_name(setting_data)

	# Use settings from previous game if available.
	if TransferData.initialized:
		rng_seed = TransferData.rng_seed
		rng_seed = _ref_RandomNumber.get_initial_seed(rng_seed)
		TransferData.set_rng_seed(rng_seed)
	else:
		TransferData.set_initialized(true)

		# Load debug seed from setting.json.
		TransferData.set_debug_seed(rng_seed)
		# Generate a new one if debug seed is invalid.
		rng_seed = _ref_RandomNumber.get_initial_seed(rng_seed)
		TransferData.set_rng_seed(rng_seed)

		TransferData.set_wizard_mode(wizard_mode)
		TransferData.set_palette_name(palette_name)
		TransferData.set_show_full_map(show_full_map)

	emit_signal(SignalTag.SETTING_LOADED)


# Refer: PlayerInput.
func save_setting(input_tag: String) -> void:
	emit_signal(SignalTag.SETTING_SAVED, input_tag)


func _get_rng_seed(setting: Dictionary) -> int:
	var random: int

	if setting.has(SEED) and (setting[SEED] is float):
		random = setting[SEED] as int
		return 0 if random < 1 else random
	return 0


func _get_palette_name(setting: Dictionary) -> String:
	if setting.has(PALETTE) and (setting[PALETTE] is String):
		return setting[PALETTE]
	return ""


func _get_bool(setting: Dictionary, option: String) -> bool:
	if setting.has(option):
		match typeof(setting[option]):
			TYPE_BOOL:
				return setting[option]
			TYPE_REAL:
				return setting[option] >= 1
	return false
