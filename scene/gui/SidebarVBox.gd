extends VBoxContainer
class_name SidebarVBox


const STATE := "Upper/State"
const HELP := "Lower/Help"
const VERSION := "Lower/Version"
const SEED := "Lower/Seed"

const NODE_TO_LIGHT_COLOR := {
	STATE: true,
	HELP: false,
	VERSION: false,
	SEED: false,
}
const CHILD_REFERENCE := {
	NodeTag.SIDEBAR_VBOX_HELPER: [NodeTag._PC_STATE,],
}

var _ref_Palette: Palette

var _sidebar_seed := ""
var _sidebar_version := ""
var _pc_state: PcState


func _on_GameSetting_setting_loaded(setting: GameSetting) -> void:
	_set_seed(setting.get_rng_seed())
	_set_version(setting.get_wizard_mode())


func _on_RandomNumber_seed_updated(rng_seed: int) -> void:
	_set_seed(rng_seed)


func _on_InitWorld_world_initialized() -> void:
	_set_reference()
	_set_node_color()

	$"Upper/State".text = $SidebarVBoxHelper.get_state_item(true)

	$"Lower/Version".text = _sidebar_version
	$"Lower/Help".text = SidebarText.HELP
	$"Lower/Seed".text = _sidebar_seed


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		$"Upper/State".text = $SidebarVBoxHelper.get_state_item(true)


func _on_EndGame_game_over(win: bool) -> void:
	$"Upper/State".text = SidebarText.GAME_OVER % [
		$SidebarVBoxHelper.get_state_item(true), _get_over(win)
	]


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == ScreenTag.MAIN)


func _on_PlayerInput_special_key_pressed(input_tag: String) -> void:
	var state_text: String = $SidebarVBoxHelper.get_state_item(false)

	match input_tag:
		InputTag.USE_POWER:
			if _pc_state.is_using_power:
				state_text = $SidebarVBoxHelper.get_state_power(false)
			$"Upper/State".text = state_text
		InputTag.ANY_WIZARD_KEY:
			$"Upper/State".text= $SidebarVBoxHelper.get_state_item(true)


func _set_node_color() -> void:
	for i in NODE_TO_LIGHT_COLOR.keys():
		get_node(i).modulate = _ref_Palette.get_text_color(
				NODE_TO_LIGHT_COLOR[i])


func _set_seed(rng_seed: int) -> void:
	var str_seed := String(rng_seed)
	var head := str_seed.substr(0, 3)
	var body := str_seed.substr(3, 3)
	var tail := str_seed.substr(6)

	_sidebar_seed = SidebarText.SEED.format([head, body, tail])


func _set_version(is_wizard: bool) -> void:
	# Wizard mode, parse error.
	if is_wizard:
		pass
	_sidebar_version = SidebarText.VERSION


func _get_over(win: bool) -> String:
	if win:
		return SidebarText.WIN
	return SidebarText.LOSE


func _set_reference() -> void:
	_pc_state = ObjectState.get_state($FindObject.pc)
	NodeHelper.set_child_reference(self, CHILD_REFERENCE)
