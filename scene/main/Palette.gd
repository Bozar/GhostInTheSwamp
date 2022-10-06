extends Node2D
class_name Palette


const PALETTE_EXE_PATH := "data/"
const PALETTE_RES_PATH := "res://bin/"
const JSON_EXTENSION := ".json"
const PATH_TO_FAIL_SAFE := "res://user/palette/%s.json"

const BACKGROUND := "background"
const INDICATOR := "indicator"

const GROUND := "ground"
const TRAP := "trap"
const BUILDING := "building"
const ACTOR := "actor"
const GUI_TEXT := "gui_text"

const DARK_GROUND := "dark_ground"
const DARK_TRAP := "dark_trap"
const DARK_BUILDING := "dark_building"
const DARK_ACTOR := "dark_actor"
const DARK_GUI_TEXT := "dark_gui_text"

const COLOR_VALUE := "color_value"

const HTML_COLOR_REGEX := "^#{0,1}([0-9A-Fa-f]{3}){1,2}$"

# https://coolors.co/f8f9fa-e9ecef-dee2e6-ced4da-adb5bd-6c757d-495057-343a40-212529
const BLACK := "#212529"
const GREY := "#6C757D"
const DARK_GREY := "#343A40"
const WHITE := "#ADB5BD"

# https://coolors.co/d8f3dc-b7e4c7-95d5b2-74c69d-52b788-40916c-2d6a4f-1b4332-081c15
const GREEN := "#52B788"
const DARK_GREEN := "#2D6A4F"

# https://coolors.co/f8b945-dc8a14-b9690b-854e19-a03401
const ORANGE := "#F8B945"
const DARK_ORANGE := "#854E19"

const DEBUG := "#FE4A49"

const DEFAULTTAG_TO_COLOR := {
	BACKGROUND: BLACK,
	INDICATOR: GREY,

	GROUND: GREY,
	TRAP: ORANGE,
	BUILDING: GREY,
	ACTOR: GREEN,
	GUI_TEXT: WHITE,

	DARK_GROUND: DARK_GREY,
	DARK_TRAP: DARK_ORANGE,
	DARK_BUILDING: DARK_GREY,
	DARK_ACTOR: DARK_GREEN,
	DARK_GUI_TEXT: GREY,

	# INDICATOR: GREY,
	# BACKGROUND: BLACK,

	# GROUND: GREY,
	# TRAP: GREY,
	# BUILDING: GREY,
	# ACTOR: WHITE,
	# GUI_TEXT: WHITE,

	# DARK_GROUND: DARK_GREY,
	# DARK_TRAP: DARK_GREY,
	# DARK_BUILDING: DARK_GREY,
	# DARK_ACTOR: GREY,
	# DARK_GUI_TEXT: GREY,
}

const TAG_TO_COLOR := {}


static func get_default_color(main_tag: String) -> String:
	match main_tag:
		MainTag.GROUND:
			return TAG_TO_COLOR[GROUND]
		MainTag.TRAP:
			return TAG_TO_COLOR[TRAP]
		MainTag.BUILDING:
			return TAG_TO_COLOR[BUILDING]
		MainTag.ACTOR:
			return TAG_TO_COLOR[ACTOR]
		MainTag.INDICATOR:
			return TAG_TO_COLOR[INDICATOR]
		_:
			return DEBUG


static func get_dark_color(main_tag: String) -> String:
	match main_tag:
		MainTag.GROUND:
			return TAG_TO_COLOR[DARK_GROUND]
		MainTag.TRAP:
			return TAG_TO_COLOR[DARK_TRAP]
		MainTag.BUILDING:
			return TAG_TO_COLOR[DARK_BUILDING]
		MainTag.ACTOR:
			return TAG_TO_COLOR[DARK_ACTOR]
		_:
			return DEBUG


static func set_default_color(set_sprite: Sprite, main_tag: String) -> void:
	var new_color: String = get_default_color(main_tag)
	set_sprite.modulate = new_color


static func set_dark_color(set_sprite: Sprite, main_tag: String) -> void:
	var new_color: String = get_dark_color(main_tag)
	set_sprite.modulate = new_color


static func get_text_color(is_light_color: bool) -> String:
	if is_light_color:
		return TAG_TO_COLOR[GUI_TEXT]
	return TAG_TO_COLOR[DARK_GUI_TEXT]


func _on_Setting_setting_loaded() -> void:
	var palette := _load_palette(TransferData.palette_name)
	var has_color_value := palette.get(COLOR_VALUE) is Dictionary
	var color_regex := RegEx.new()
	color_regex.compile(HTML_COLOR_REGEX)

	for i in DEFAULTTAG_TO_COLOR.keys():
		TAG_TO_COLOR[i] = ""
		if _dict_has_string(palette, i):
			if has_color_value \
					and _dict_has_string(palette[COLOR_VALUE], palette[i]):
				TAG_TO_COLOR[i] = palette[COLOR_VALUE][palette[i]]
			else:
				TAG_TO_COLOR[i] = palette[i]

		if color_regex.search(TAG_TO_COLOR[i]) == null:
			# print("Invalid color: " + i)
			TAG_TO_COLOR[i] = DEFAULTTAG_TO_COLOR[i]

	VisualServer.set_default_clear_color(TAG_TO_COLOR[BACKGROUND])


func _dict_has_string(this_dict: Dictionary, this_key: String) -> bool:
	return this_dict.get(this_key) is String


func _load_palette(palette_name: String) -> Dictionary:
	var json_parser: FileParser

	for i in [PALETTE_EXE_PATH, PALETTE_RES_PATH]:
		for j in ["", JSON_EXTENSION]:
			json_parser = FileIoHelper.read_as_json(i + palette_name + j)
			if json_parser.parse_success:
				return json_parser.output_json
	return _try_fail_safe_palette(palette_name)


func _try_fail_safe_palette(palette_name: String) -> Dictionary:
	var fail_safe := palette_name.strip_edges().replace(JSON_EXTENSION, "") \
			.to_lower()
	var output_json := FileIoHelper.read_as_json(PATH_TO_FAIL_SAFE % fail_safe)

	if output_json.parse_success:
		return output_json.output_json
	return {}
