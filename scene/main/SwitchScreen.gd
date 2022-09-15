extends Node2D
class_name SwitchScreen


signal screen_switched(source, target)


func set_screen(source: int, target: int) -> void:
	emit_signal(SignalTag.SCREEN_SWITCHED, source, target)
