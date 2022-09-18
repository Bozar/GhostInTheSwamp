extends VBoxContainer
class_name DebugVBox


const HEADER := "Header"
const SETTING := "SettingVBox"
const FOOTER := "Footer"
const SEED_LABEL := "SettingVBox/Seed/GuiText"
const SEED_INPUT := "SettingVBox/Seed/GuiInput"
const WIZARD_LABEL := "SettingVBox/WizardMode/GuiText"
const WIZARD_INPUT := "SettingVBox/WizardMode/GuiInput"
const PALETTE_LABEL := "SettingVBox/Palette/GuiText"
const PALETTE_INPUT := "SettingVBox/Palette/GuiInput"
const MAP_LABEL := "SettingVBox/ShowFullMap/GuiText"
const MAP_INPUT := "SettingVBox/ShowFullMap/GuiInput"

const LABEL_TO_NAME := {
	HEADER: "# Debug Menu\n\n[Esc: Exit debug]",
	FOOTER: "Parse error: setting.json.",
	SEED_LABEL: "Seed",
	WIZARD_LABEL: "Wizard",
	PALETTE_LABEL: "Palette",
	MAP_LABEL: "ShowMap",
}
const INPUT_TO_PLACEHOLDER := {
	SEED_INPUT: "DEFAULT: 0",
	WIZARD_INPUT: "DEFAULT: FALSE",
	PALETTE_INPUT: "EXAMPLE: BLUE, GREY",
	MAP_INPUT: "DEFAULT: FALSE",
}
const NODE_TO_COLOR := {
	HEADER: true,
	SETTING: true,
	FOOTER: false,
}

const TRUE_PATTERN := "^(true|t|yes|y|[1-9]\\d*)$"
const ARRAY_SEPARATOR := ","
const TRAILING_SPACE := " "
const SEED_SEPARATOR_PATTERN := "[-,.\\s]"

var _ref_Palette: Palette

var _seed_reg := RegEx.new()
var _true_reg := RegEx.new()


func _init() -> void:
	_seed_reg.compile(SEED_SEPARATOR_PATTERN)
	_true_reg.compile(TRUE_PATTERN)


func _ready() -> void:
	add_to_group(MainTag.GAME_SETTING)
	visible = false


func _on_GameSetting_setting_loaded() -> void:
	# Debug input box requires debug_seed, not rng_seed.
	_load_as_string(TransferData.debug_seed, SEED_INPUT)
	_load_as_string(TransferData.wizard_mode, WIZARD_INPUT)
	_load_as_string(TransferData.show_full_map, MAP_INPUT)
	_load_as_string(TransferData.palette_name, PALETTE_INPUT)


func _on_InitWorld_world_initialized() -> void:
	_init_node_color()
	_init_node_text()


func _on_SwitchScreen_screen_switched(source: int, target: int) -> void:
	if target == ScreenTag.DEBUG:
		visible = true
		get_node(SEED_INPUT).grab_focus()
		get_node(SEED_INPUT).caret_position = 0
	elif source == ScreenTag.DEBUG:
		visible = false


func _on_GameSetting_setting_saved(input_tag: String) -> void:
	TransferData.set_debug_seed(_save_as_int(SEED_INPUT), self)
	TransferData.set_wizard_mode(_save_as_bool(WIZARD_INPUT), self)
	TransferData.set_palette_name(_save_as_string(PALETTE_INPUT), self)
	TransferData.set_show_full_map(_save_as_bool(MAP_INPUT), self)

	# Do not change rng_seed if replay the same dungeon. Otherwise, overwrite
	# rng_seed with debug_seed.
	if input_tag != InputTag.REPLAY_DUNGEON:
		TransferData.set_rng_seed(TransferData.debug_seed, self)


func _init_node_text() -> void:
	for i in LABEL_TO_NAME.keys():
		get_node(i).text = LABEL_TO_NAME[i]
	for i in INPUT_TO_PLACEHOLDER.keys():
		get_node(i).placeholder_text = INPUT_TO_PLACEHOLDER[i]
	if not TransferData.json_parse_error:
		get_node(FOOTER).text = ""


func _init_node_color() -> void:
	for i in NODE_TO_COLOR.keys():
		get_node(i).modulate = _ref_Palette.get_text_color(NODE_TO_COLOR[i])


func _load_from_array(source: Array, target: String) -> void:
	var tmp := ""

	for i in range(0, source.size()):
		if i < source.size() - 1:
			tmp += source[i] + ARRAY_SEPARATOR + TRAILING_SPACE
		else:
			tmp += source[i]
	get_node(target).text = tmp


func _load_as_string(source, target: String) -> void:
	get_node(target).text = String(source).to_lower()


func _save_as_array(source: String) -> Array:
	var tmp = get_node(source).text.to_lower()

	tmp = tmp.split(ARRAY_SEPARATOR)
	for i in range(0, tmp.size()):
		tmp[i] = tmp[i].strip_edges()
	return tmp


func _save_as_bool(source: String) -> bool:
	return _true_reg.search(_save_as_string(source)) != null


func _save_as_int(source: String) -> int:
	var str_digit: String = get_node(source).text
	return int(_seed_reg.sub(str_digit, "", true))


func _save_as_string(source: String) -> String:
	return get_node(source).text.to_lower().strip_edges()
