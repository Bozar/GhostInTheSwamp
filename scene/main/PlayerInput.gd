extends InputTemplate
class_name PlayerInput


const CHILD_REFERENCE := {
	NodeTag.PC_ACTION:	[
		NodeTag.REF_SCHEDULE,
		NodeTag.REF_REMOVE_OBJECT,
		NodeTag.REF_RANDOM_NUMBER,
		NodeTag.REF_END_GAME,
		NodeTag.REF_CREATE_OBJECT,
	],
}

signal special_key_pressed(input_tag)

var _ref_Schedule: Schedule
var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_EndGame: EndGame
var _ref_SwitchScreen: SwitchScreen
var _ref_CreateObject: CreateObject
var _ref_GameSetting: GameSetting

var _end_game := false


func _unhandled_input(event: InputEvent) -> void:
	var may_have_conflict := true
	var input_tag := ""

	if _verify_input(event, InputTag.QUIT):
		_ref_EndGame.quit()
	elif _verify_input(event, InputTag.FORCE_RELOAD):
		_ref_GameSetting.save_setting(InputTag.FORCE_RELOAD)
		_ref_EndGame.reload()
	elif _verify_input(event, InputTag.REPLAY_DUNGEON):
		_ref_GameSetting.save_setting(InputTag.REPLAY_DUNGEON)
		_ref_EndGame.reload()
	elif _verify_input(event, InputTag.COPY_SEED):
		OS.set_clipboard(TransferData.rng_seed as String)
	elif _verify_input(event, InputTag.OPEN_HELP):
		_ref_SwitchScreen.set_screen(ScreenTag.HELP)
	elif _verify_input(event, InputTag.OPEN_DEBUG):
		_ref_SwitchScreen.set_screen(ScreenTag.DEBUG)
	elif _end_game:
		if _verify_input(event, InputTag.RELOAD):
			_ref_GameSetting.save_setting(InputTag.RELOAD)
			_ref_EndGame.reload()
	else:
		may_have_conflict = false
	if may_have_conflict:
		return

	if TransferData.wizard_mode:
		input_tag = _get_wizard_key(event)
		if input_tag != "":
			$PcAction.press_wizard_key(input_tag)
			emit_signal(SignalTag.SPECIAL_KEY, InputTag.ANY_WIZARD_KEY)

	input_tag = _get_move_direction(event)
	if input_tag != "":
		$PcAction.move(input_tag)
	elif _verify_input(event, InputTag.USE_POWER):
		$PcAction.use_power()
		emit_signal(SignalTag.SPECIAL_KEY, InputTag.USE_POWER)
	elif _verify_input(event, InputTag.TOGGLE_SIGHT):
		$PcAction.toggle_sight()


func _on_InitWorld_world_initialized() -> void:
	NodeHelper.set_child_reference(self, CHILD_REFERENCE)
	$PcAction.set_reference()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		$PcFov.render()
		$PcAction.start_turn()
		set_process_unhandled_input(true)


func _on_Schedule_turn_ended(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		set_process_unhandled_input(false)


func _on_EndGame_game_over(win: bool) -> void:
	_end_game = true
	$PcFov.render(win)
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
