extends VBoxContainer
class_name Game_SidebarVBox


const STATE := "Upper/State"
const MESSAGE := "Upper/Message"
const HELP := "Lower/Help"
const VERSION := "Lower/Version"
const SEED := "Lower/Seed"

const NODE_TO_LIGHT_COLOR := {
	STATE: true,
	MESSAGE: true,
	HELP: false,
	VERSION: false,
	SEED: false,
}

var _ref_PCState: Game_PCState
var _ref_Palette: Game_Palette

var _ref_State: Label
var _ref_Message: Label

var _sidebar_seed := ""
var _sidebar_version := ""


func _ready() -> void:
	_ref_State = get_node(STATE)
	_ref_Message = get_node(MESSAGE)


func _on_GameSetting_setting_loaded(setting: Game_GameSetting) -> void:
	_set_seed(setting.get_rng_seed())
	_set_version(setting.get_wizard_mode())


func _on_RandomNumber_seed_updated(rng_seed: int) -> void:
	_set_seed(rng_seed)


func _on_InitWorld_world_initialized() -> void:
	_set_node_color()

	_ref_State.text = _get_state()
	_ref_Message.text = ""
	# _ref_State.max_lines_visible = 4
	# _ref_Message.text = Game_SidebarText.SEPARATOR \
	# 		+ "↑|3: Trcik\n↑|3: Trcik\n↑|3: Trcik\n↑|3: Trcik\n↑|3: Trcik"

	get_node(VERSION).text = _sidebar_version
	get_node(HELP).text = Game_SidebarText.HELP
	get_node(SEED).text = _sidebar_seed


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		_ref_State.text = _get_state()


func _on_EndGame_game_over(win: bool) -> void:
	_ref_State.text = _get_state()
	if win:
		_ref_Message.text = Game_SidebarText.WIN
	else:
		_ref_Message.text = Game_SidebarText.LOSE


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == Game_ScreenTag.MAIN)


func _set_node_color() -> void:
	for i in NODE_TO_LIGHT_COLOR.keys():
		get_node(i).modulate = _ref_Palette.get_text_color(
				NODE_TO_LIGHT_COLOR[i])


func _set_seed(rng_seed: int) -> void:
	var str_seed := String(rng_seed)
	var head := str_seed.substr(0, 3)
	var body := str_seed.substr(3, 3)
	var tail := str_seed.substr(6)

	_sidebar_seed = Game_SidebarText.SEED.format([head, body, tail])


func _set_version(is_wizard: bool) -> void:
	# Wizard mode, parse error.
	if is_wizard:
		pass
	_sidebar_version = Game_SidebarText.VERSION


func _get_state() -> String:
	return Game_SidebarText.STATE


func _get_power() -> String:
	return ""
