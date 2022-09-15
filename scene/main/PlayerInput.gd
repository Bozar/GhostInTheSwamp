extends InputTemplate
class_name PlayerInput


const CHILD_REFERENCE := {
	NodeTag.PC_ACTION:	[
		NodeTag.REF_SCHEDULE,
		NodeTag.REF_DUNGEON_BOARD,
		NodeTag.REF_REMOVE_OBJECT,
		NodeTag.REF_RANDOM_NUMBER,
		NodeTag.REF_END_GAME,
		NodeTag.REF_CREATE_OBJECT,
		NodeTag.REF_PALETTE,

		NodeTag._PC_STATE
	],
}

signal special_key_pressed(input_tag)

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_EndGame: EndGame
var _ref_SwitchScreen: SwitchScreen
var _ref_CreateObject: CreateObject
var _ref_GameSetting: GameSetting
var _ref_Palette: Palette

var _pc_state: PcState

var _end_game := false


func _unhandled_input(event: InputEvent) -> void:
	var may_have_conflict := true
	var input_tag := ""

	if _verify_input(event, InputTag.QUIT):
		ObjectState.remove_all()
		get_tree().quit()
	elif _verify_input(event, InputTag.FORCE_RELOAD):
		$ReloadGame.reload()
	elif _verify_input(event, InputTag.REPLAY_DUNGEON):
		_ref_GameSetting.save_setting()
		$ReloadGame.reload()
	elif _verify_input(event, InputTag.COPY_SEED):
		OS.set_clipboard(_ref_RandomNumber.get_rng_seed() as String)
	elif _verify_input(event, InputTag.OPEN_HELP):
		_ref_SwitchScreen.set_screen(ScreenTag.MAIN, ScreenTag.HELP)
	elif _verify_input(event, InputTag.OPEN_DEBUG):
		_ref_SwitchScreen.set_screen(ScreenTag.MAIN, ScreenTag.DEBUG)
	elif _end_game:
		if _verify_input(event, InputTag.RELOAD):
			$ReloadGame.reload()
	else:
		may_have_conflict = false
	if may_have_conflict:
		return

	if _ref_GameSetting.get_wizard_mode():
		input_tag = _get_wizard_key(event)
		if input_tag != "":
			$PcAction.press_wizard_key(input_tag)
			emit_signal(SignalTag.SPECIAL_KEY,
					InputTag.ANY_WIZARD_KEY)

	input_tag = _get_move_direction(event)
	if input_tag != "":
		$PcAction.move(input_tag)
	elif _verify_input(event, InputTag.USE_POWER):
		$PcAction.use_power()
		emit_signal(SignalTag.SPECIAL_KEY, InputTag.USE_POWER)
	elif _verify_input(event, InputTag.TOGGLE_SIGHT):
		$PcAction.toggle_sight()


func _on_InitWorld_world_initialized() -> void:
	_pc_state = ObjectState.get_state($FindObject.pc)
	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		$PcAction.start_turn()
		set_process_unhandled_input(true)


func _on_Schedule_turn_ended(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		set_process_unhandled_input(false)


func _on_EndGame_game_over(win: bool) -> void:
	_end_game = true
	$PcAction.game_over(win)
	set_process_unhandled_input(true)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	set_process_unhandled_input(target == ScreenTag.MAIN)


func _get_move_direction(event: InputEvent) -> String:
	for i in InputTag.MOVE_INPUT:
		if event.is_action_pressed(i):
			return i
	return ""


func _get_wizard_key(event: InputEvent) -> String:
	for i in InputTag.WIZARD_INPUT:
		if event.is_action_pressed(i):
			return i
	return ""
