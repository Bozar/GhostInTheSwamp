extends Node2D
class_name SwitchScreen


signal screen_switched(source, target)

var _source_screen := ScreenTag.MAIN


func set_screen(target_screen: int) -> void:
	emit_signal(SignalTag.SCREEN_SWITCHED, _source_screen, target_screen)
	_source_screen = target_screen
