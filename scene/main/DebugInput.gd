extends InputTemplate
class_name DebugInput


var _ref_SwitchScreen: SwitchScreen


func _unhandled_input(event: InputEvent) -> void:
	if _verify_input(event, InputTag.CLOSE_MENU):
		_ref_SwitchScreen.set_screen(ScreenTag.MAIN)


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	set_process_unhandled_input(target == ScreenTag.DEBUG)
