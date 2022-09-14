extends Game_InputTemplate
class_name Game_PlayerInput


const CHILD_REFERENCE := {
	Game_NodeTag.PC_ACTION:	[
		Game_NodeTag.REF_PC_STATE,

		Game_NodeTag.REF_SCHEDULE,
		Game_NodeTag.REF_DUNGEON_BOARD,
		Game_NodeTag.REF_REMOVE_OBJECT,
		Game_NodeTag.REF_OBJECT_STATE,
		Game_NodeTag.REF_RANDOM_NUMBER,
		Game_NodeTag.REF_END_GAME,
		Game_NodeTag.REF_CREATE_OBJECT,
		Game_NodeTag.REF_PALETTE,
	],
}

signal special_key_pressed(input_tag)

var _ref_Schedule: Game_Schedule
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_RemoveObject: Game_RemoveObject
var _ref_ObjectState: Game_ObjectState
var _ref_RandomNumber: Game_RandomNumber
var _ref_EndGame: Game_EndGame
var _ref_SwitchScreen: Game_SwitchScreen
var _ref_CreateObject: Game_CreateObject
var _ref_GameSetting: Game_GameSetting
var _ref_Palette: Game_Palette

var _ref_PcState: Game_PcState

var _end_game := false


func _unhandled_input(event: InputEvent) -> void:
	var may_have_conflict := true
	var input_tag := ""

	if _verify_input(event, Game_InputTag.QUIT):
		get_tree().quit()
	elif _verify_input(event, Game_InputTag.FORCE_RELOAD):
		$ReloadGame.reload()
	elif _verify_input(event, Game_InputTag.REPLAY_DUNGEON):
		_ref_GameSetting.save_setting()
		$ReloadGame.reload()
	elif _verify_input(event, Game_InputTag.COPY_SEED):
		OS.set_clipboard(_ref_RandomNumber.get_rng_seed() as String)
	elif _verify_input(event, Game_InputTag.OPEN_HELP):
		_ref_SwitchScreen.set_screen(Game_ScreenTag.MAIN, Game_ScreenTag.HELP)
	elif _verify_input(event, Game_InputTag.OPEN_DEBUG):
		_ref_SwitchScreen.set_screen(Game_ScreenTag.MAIN, Game_ScreenTag.DEBUG)
	elif _end_game:
		if _verify_input(event, Game_InputTag.RELOAD):
			$ReloadGame.reload()
	else:
		may_have_conflict = false
	if may_have_conflict:
		return

	if _ref_GameSetting.get_wizard_mode():
		input_tag = _get_wizard_key(event)
		if input_tag != "":
			$PcAction.press_wizard_key(input_tag)
			emit_signal(Game_SignalTag.SPECIAL_KEY,
					Game_InputTag.ANY_WIZARD_KEY)

	input_tag = _get_move_direction(event)
	if input_tag != "":
		$PcAction.move(input_tag)
	elif _verify_input(event, Game_InputTag.USE_POWER):
		$PcAction.use_power()
		emit_signal(Game_SignalTag.SPECIAL_KEY, Game_InputTag.USE_POWER)
	elif _verify_input(event, Game_InputTag.TOGGLE_SIGHT):
		$PcAction.toggle_sight()


func _on_InitWorld_world_initialized() -> void:
	$NodeHelper.set_child_reference(CHILD_REFERENCE)
	set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		$PcAction.start_turn()
		set_process_unhandled_input(true)


func _on_Schedule_turn_ended(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		set_process_unhandled_input(false)


func _on_EndGame_game_over(win: bool) -> void:
	_end_game = true
	$PcAction.game_over(win)
	set_process_unhandled_input(true)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	set_process_unhandled_input(target == Game_ScreenTag.MAIN)


func _get_move_direction(event: InputEvent) -> String:
	for i in Game_InputTag.MOVE_INPUT:
		if event.is_action_pressed(i):
			return i
	return ""


func _get_wizard_key(event: InputEvent) -> String:
	for i in Game_InputTag.WIZARD_INPUT:
		if event.is_action_pressed(i):
			return i
	return ""
