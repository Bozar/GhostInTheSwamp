extends VBoxContainer
class_name Game_SidebarVBox


const STATE := "Upper/State"
const MESSAGE := "Upper/Message"
const HELP := "Lower/Help"
const VERSION := "Lower/Version"
const SEED := "Lower/Seed"

var _ref_RandomNumber: Game_RandomNumber
var _ref_GameSetting: Game_GameSetting
var _ref_Palette: Game_Palette

var _node_to_color: Dictionary


func _on_InitWorld_world_selected(_new_world: String) -> void:
	_node_to_color = {
		STATE: _ref_Palette.get_text_color(true),
		MESSAGE: _ref_Palette.get_text_color(true),
		HELP: _ref_Palette.get_text_color(false),
		VERSION: _ref_Palette.get_text_color(false),
		SEED: _ref_Palette.get_text_color(false),
	}
	_set_color()

	get_node(STATE).text = _get_state()
	get_node(MESSAGE).text = ""

	get_node(VERSION).text = _get_version()
	get_node(HELP).text = Game_SidebarText.HELP
	get_node(SEED).text = _get_seed()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if not current_sprite.is_in_group(Game_SubTag.PC):
		return
	get_node(STATE).text = _get_state()


func _on_EndGame_game_over(win: bool) -> void:
	get_node(STATE).text = _get_state()
	if win:
		get_node(MESSAGE).text = Game_SidebarText.WIN
	else:
		get_node(MESSAGE).text = Game_SidebarText.LOSE


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == Game_ScreenTag.MAIN)


func _set_color() -> void:
	for i in _node_to_color.keys():
		get_node(i).modulate = _node_to_color[i]


func _get_state() -> String:
	return Game_SidebarText.STATE


func _get_seed() -> String:
	var rng_seed := String(_ref_RandomNumber.rng_seed)
	var head := rng_seed.substr(0, 3)
	var body := rng_seed.substr(3, 3)
	var tail := rng_seed.substr(6)

	return Game_SidebarText.SEED.format([head, body, tail])


func _get_version() -> String:
	# Wizard mode, parse error.
	return Game_SidebarText.VERSION
