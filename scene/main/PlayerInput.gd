extends InputTemplate
class_name PlayerInput


signal special_key_pressed(input_tag)

var _ref_Schedule: Schedule
var _ref_RemoveObject: RemoveObject
var _ref_RandomNumber: RandomNumber
var _ref_SwitchScreen: SwitchScreen
var _ref_CreateObject: CreateObject
var _ref_Setting: Setting

var _game_over := false


func _unhandled_input(event: InputEvent) -> void:
	var may_have_conflict := true
	var input_tag := ""

	if _verify_input(event, InputTag.QUIT):
		EndGame.quit()
	elif _verify_input(event, InputTag.FORCE_RELOAD):
		_ref_Setting.save_setting(InputTag.FORCE_RELOAD)
		EndGame.reload()
	elif _verify_input(event, InputTag.REPLAY_DUNGEON):
		_ref_Setting.save_setting(InputTag.REPLAY_DUNGEON)
		EndGame.reload()
	elif _verify_input(event, InputTag.COPY_SEED):
		OS.set_clipboard(TransferData.rng_seed as String)
	elif _verify_input(event, InputTag.OPEN_HELP):
		_ref_SwitchScreen.set_screen(ScreenTag.HELP)
	elif _verify_input(event, InputTag.OPEN_DEBUG):
		_ref_SwitchScreen.set_screen(ScreenTag.DEBUG)
	elif _game_over:
		if _verify_input(event, InputTag.RELOAD):
			_ref_Setting.save_setting(InputTag.RELOAD)
			EndGame.reload()
	else:
		may_have_conflict = false
	if may_have_conflict:
		return

	if TransferData.wizard_mode:
		input_tag = _get_wizard_key(event)
		if input_tag != "":
			$PcAction.press_wizard_key(input_tag)
			emit_signal(SignalTag.SPECIAL_KEY, InputTag.ANY_WIZARD_KEY)
			return

	input_tag = _get_move_direction(event)
	if input_tag != "":
		$PcAction.move(input_tag)
	elif _verify_input(event, InputTag.TOGGLE_POWER_MODE):
		PcSprite.toggle_power_mode()
		emit_signal(SignalTag.SPECIAL_KEY, InputTag.TOGGLE_POWER_MODE)
	elif $PcAction.use_power and _verify_input(event, InputTag.EXIT_POWER_MODE):
		PcSprite.exit_power_mode()
		emit_signal(SignalTag.SPECIAL_KEY, InputTag.TOGGLE_POWER_MODE)
	elif _verify_input(event, InputTag.TOGGLE_SIGHT_MODE):
		ActorSight.toggle_sight_mode()
	elif _verify_input(event, InputTag.EXIT_SIGHT_MODE):
		ActorSight.toggle_sight_mode(true)
	# A turn may end when pressing a movement key or InputTag.DEV_KEY.
	if $PcAction.end_turn:
		_end_turn()


func _end_turn() -> void:
	set_process_unhandled_input(false)
	_ref_Schedule.end_turn()


func _on_InitWorld_world_initialized() -> void:
	$PcAction.set_reference()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		$PcFov.render()
		$PcAction.start_turn()
		set_process_unhandled_input(true)


func _on_Progress_game_over(win: bool) -> void:
	_game_over = true
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
