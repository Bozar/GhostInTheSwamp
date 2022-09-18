extends VBoxContainer
class_name DebugVBox


const HEADER := "Header"
const SETTING := "SettingVBox"
const FOOTER := "Footer"
const SEED_LABEL := "SettingVBox/Seed/GuiText"
const SEED_INPUT := "SettingVBox/Seed/GuiInput"
const INCLUDE_LABEL := "SettingVBox/IncludeWorld/GuiText"
const INCLUDE_INPUT := "SettingVBox/IncludeWorld/GuiInput"
const WIZARD_LABEL := "SettingVBox/WizardMode/GuiText"
const WIZARD_INPUT := "SettingVBox/WizardMode/GuiInput"
const EXCLUDE_LABEL := "SettingVBox/ExcludeWorld/GuiText"
const EXCLUDE_INPUT := "SettingVBox/ExcludeWorld/GuiInput"
const SHOW_LABEL := "SettingVBox/ShowFullMap/GuiText"
const SHOW_INPUT := "SettingVBox/ShowFullMap/GuiInput"
const MOUSE_LABEL := "SettingVBox/MouseInput/GuiText"
const MOUSE_INPUT := "SettingVBox/MouseInput/GuiInput"

const HEADER_TEXT := "# Debug Menu\n\n[Esc: Exit debug]"
const SEED_TEXT := "Seed"
const SEED_PLACEHOLDER := "DEFAULT: 0"
const INCLUDE_TEXT := "Include"
const INCLUDE_PLACEHOLDER := "EXAMPLE: BARON, FACTORY, RAILGUN"
const WIZARD_TEXT := "Wizard"
const DEFAULT_FALSE_PLACEHOLDER := "DEFAULT: FALSE"
const EXCLUDE_TEXT := "Exclude"
const EXCLUDE_PLACEHOLDER := "INITIAL: DEMO"
const SHOW_TEXT := "ShowMap"
const MOUSE_TEXT := "Mouse"

const TRUE_PATTERN := "^(true|t|yes|y|[1-9]\\d*)$"
const VERSION_PREFIX := "Version: "
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
	visible = false


func _on_InitWorld_world_selected(_new_world: String) -> void:
	_init_text_color()
	_init_label_text()
	_init_input_placeholder()
	_load_settings()


func _on_SwitchScreen_screen_switched(source: int, target: int) -> void:
	if target == ScreenTag.DEBUG:
		visible = true
		get_node(SEED_INPUT).grab_focus()
		get_node(SEED_INPUT).caret_position = 0
	elif source == ScreenTag.DEBUG:
		visible = false


func _on_GameSetting_setting_saved(_input_tag: String) -> void:
	_save_settings()


func _init_label_text() -> void:
	var label_to_text := {
		HEADER: HEADER_TEXT,
		FOOTER: SidebarText.VERSION.format([VERSION_PREFIX]),
		SEED_LABEL: SEED_TEXT,
		INCLUDE_LABEL: INCLUDE_TEXT,
		WIZARD_LABEL: WIZARD_TEXT,
		EXCLUDE_LABEL: EXCLUDE_TEXT,
		SHOW_LABEL: SHOW_TEXT,
		MOUSE_LABEL: MOUSE_TEXT,
	}

	for i in label_to_text.keys():
		get_node(i).text = label_to_text[i]


func _init_input_placeholder() -> void:
	var input_to_placeholder := {
		SEED_INPUT: SEED_PLACEHOLDER,
		INCLUDE_INPUT: INCLUDE_PLACEHOLDER,
		WIZARD_INPUT: DEFAULT_FALSE_PLACEHOLDER,
		EXCLUDE_INPUT: EXCLUDE_PLACEHOLDER,
		SHOW_INPUT: DEFAULT_FALSE_PLACEHOLDER,
		MOUSE_INPUT: DEFAULT_FALSE_PLACEHOLDER,
	}

	for i in input_to_placeholder.keys():
		get_node(i).placeholder_text = input_to_placeholder[i]


func _init_text_color() -> void:
	var node_to_color := {
		HEADER: true,
		SETTING: true,
		FOOTER: false,
	}

	for i in node_to_color:
		get_node(i).modulate = _ref_Palette.get_text_color(node_to_color[i])


func _load_settings() -> void:
	_load_as_string(TransferData.rng_seed, SEED_INPUT)
	_load_as_string(TransferData.wizard_mode, WIZARD_INPUT)
	_load_as_string(TransferData.show_full_map, SHOW_INPUT)
	_load_as_string(TransferData.mouse_input, MOUSE_INPUT)

	_load_from_array(TransferData.include_world, INCLUDE_INPUT)
	_load_from_array(TransferData.exclude_world, EXCLUDE_INPUT)


func _save_settings() -> void:
	TransferData.rng_seed = _save_as_int(SEED_INPUT)

	TransferData.include_world = _save_as_array(INCLUDE_INPUT)
	TransferData.exclude_world = _save_as_array(EXCLUDE_INPUT)

	TransferData.wizard_mode = _save_as_bool(WIZARD_INPUT)
	TransferData.show_full_map = _save_as_bool(SHOW_INPUT)
	TransferData.mouse_input = _save_as_bool(MOUSE_INPUT)


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
	source = get_node(source).text.to_lower().strip_edges()
	return _true_reg.search(source) != null


func _save_as_int(source: String) -> int:
	var str_digit: String = get_node(source).text
	return int(_seed_reg.sub(str_digit, "", true))
