extends VBoxContainer
class_name SidebarVBox


const STATE := "Upper/State"
const HELP := "Lower/Help"
const VERSION := "Lower/Version"
const SEED := "Lower/Seed"

const NODE_TO_COLOR := {
	STATE: true,
	HELP: false,
	VERSION: false,
	SEED: false,
}


func _on_InitWorld_world_initialized() -> void:
	$SidebarVBoxHelper.set_reference()
	_set_node_color()

	get_node(STATE).text = $SidebarVBoxHelper.get_state_item()

	get_node(VERSION).text = _get_version()
	get_node(HELP).text = SidebarText.HELP
	get_node(SEED).text = _get_seed()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		get_node(STATE).text = $SidebarVBoxHelper.get_state_item()


func _on_Progress_game_over(win: bool) -> void:
	get_node(STATE).text = SidebarText.GAME_OVER % [
		$SidebarVBoxHelper.get_state_item(), _get_game_over(win)
	]


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	visible = (target == ScreenTag.MAIN)


func _on_PlayerInput_special_key_pressed(input_tag: String) -> void:
	var state_text: String = $SidebarVBoxHelper.get_state_item(false)

	match input_tag:
		InputTag.TOGGLE_POWER:
			if ObjectState.get_state(FindObject.pc).use_power:
				state_text = $SidebarVBoxHelper.get_state_power()
			get_node(STATE).text = state_text
		InputTag.ANY_WIZARD_KEY:
			get_node(STATE).text= $SidebarVBoxHelper.get_state_item()


func _set_node_color() -> void:
	for i in NODE_TO_COLOR.keys():
		get_node(i).modulate = Palette.get_text_color(NODE_TO_COLOR[i])


func _get_seed() -> String:
	var str_seed := String(TransferData.rng_seed)
	var head := str_seed.substr(0, 3)
	var body := str_seed.substr(3, 3)
	var tail := str_seed.substr(6)

	return SidebarText.SEED % [head, body, tail]


func _get_version() -> String:
	var wizard_char := SidebarText.WIZARD if TransferData.wizard_mode else ""
	return SidebarText.VERSION % wizard_char


func _get_game_over(win: bool) -> String:
	if win:
		return SidebarText.WIN
	return SidebarText.LOSE
