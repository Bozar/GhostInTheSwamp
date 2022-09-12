extends Game_InputTemplate
class_name Game_PlayerInput


const RELOAD_GAME := "ReloadGame"
const PC_ACTION := "PCAction"

var _ref_Schedule: Game_Schedule
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_RemoveObject: Game_RemoveObject
var _ref_ObjectState: Game_ObjectState
var _ref_RandomNumber: Game_RandomNumber
var _ref_SwitchSprite: Game_SwitchSprite
var _ref_EndGame: Game_EndGame
var _ref_SwitchScreen: Game_SwitchScreen
var _ref_CreateObject: Game_CreateObject
var _ref_GameSetting: Game_GameSetting
var _ref_Palette: Game_Palette

var _ref_PCAction: Game_PCAction

var _end_game := false


func _unhandled_input(event: InputEvent) -> void:
	var may_have_conflict := true
	var input_tag := ""

	if _verify_input(event, Game_InputTag.QUIT):
		get_tree().quit()
	elif _verify_input(event, Game_InputTag.FORCE_RELOAD):
		get_node(RELOAD_GAME).reload()
	elif _verify_input(event, Game_InputTag.REPLAY_DUNGEON):
		_ref_GameSetting.save_setting()
		get_node(RELOAD_GAME).reload()
	elif _verify_input(event, Game_InputTag.COPY_SEED):
		OS.set_clipboard(_ref_RandomNumber.get_rng_seed() as String)
	elif _verify_input(event, Game_InputTag.OPEN_HELP):
		_ref_SwitchScreen.set_screen(Game_ScreenTag.MAIN, Game_ScreenTag.HELP)
	elif _verify_input(event, Game_InputTag.OPEN_DEBUG):
		_ref_SwitchScreen.set_screen(Game_ScreenTag.MAIN, Game_ScreenTag.DEBUG)
	elif _end_game:
		if _verify_input(event, Game_InputTag.RELOAD):
			get_node(RELOAD_GAME).reload()
	else:
		may_have_conflict = false
	if may_have_conflict:
		return

	if _ref_GameSetting.get_wizard_mode():
		input_tag = _get_wizard_key(event)
		if input_tag != "":
			_ref_PCAction.press_wizard_key(input_tag)

	input_tag = _get_move_direction(event)
	if input_tag != "":
		_ref_PCAction.move(input_tag)
	elif _verify_input(event, Game_InputTag.USE_POWER):
		_ref_PCAction.use_power()
	elif _verify_input(event, Game_InputTag.TOGGLE_SIGHT):
		_ref_PCAction.toggle_sight()


func _on_InitWorld_world_initializing() -> void:
	_ref_PCAction = get_node(PC_ACTION)
	_ref_PCAction.set_reference()
	set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		_ref_PCAction.start_turn()
		set_process_unhandled_input(true)


func _on_Schedule_turn_ending(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		set_process_unhandled_input(false)


func _on_EndGame_game_over(win: bool) -> void:
	_end_game = true
	_ref_PCAction.game_over(win)
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
