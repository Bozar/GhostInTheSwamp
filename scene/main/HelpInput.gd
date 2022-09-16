extends InputTemplate
class_name HelpInput


var _ref_SwitchScreen: SwitchScreen
var _ref_HelpVScroll: HelpVScroll

var _input_to_funcref: Dictionary


func _on_InitWorld_world_selected(_new_world: String) -> void:
	if _input_to_funcref.size() > 0:
		return

	_input_to_funcref = {
		InputTag.CLOSE_MENU:
			[_ref_SwitchScreen, "set_screen", [ScreenTag.MAIN]],
		InputTag.MOVE_DOWN:
			[_ref_HelpVScroll, "slide_scroll_bar", [true, true]],
		InputTag.MOVE_UP:
			[_ref_HelpVScroll, "slide_scroll_bar", [true, false]],
		InputTag.PAGE_DOWN:
			[_ref_HelpVScroll, "slide_scroll_bar", [false, true]],
		InputTag.PAGE_UP:
			[_ref_HelpVScroll, "slide_scroll_bar", [false, false]],
		InputTag.SCROLL_TO_BOTTOM:
			[_ref_HelpVScroll, "scroll_to_top_or_bottom", [true]],
		InputTag.SCROLL_TO_TOP:
			[_ref_HelpVScroll, "scroll_to_top_or_bottom", [false]],
		InputTag.NEXT_HELP:
			[_ref_HelpVScroll, "switch_help_text", [true]],
		InputTag.PREVIOUS_HELP:
			[_ref_HelpVScroll, "switch_help_text", [false]],
	}


func _unhandled_input(event: InputEvent) -> void:
	for i in _input_to_funcref.keys():
		if _verify_input(event, i):
			funcref(_input_to_funcref[i][0], _input_to_funcref[i][1]) \
					.call_funcv(_input_to_funcref[i][2])
			break


func _on_SwitchScreen_screen_switched(_source: int, target: int) -> void:
	set_process_unhandled_input(target == ScreenTag.HELP)
