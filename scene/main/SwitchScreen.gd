extends Node2D
class_name Game_SwitchScreen


const SIG_SCREEN_SWITCHED := "screen_switched"

signal screen_switched(source, target)


func set_screen(source: int, target: int) -> void:
	emit_signal(SIG_SCREEN_SWITCHED, source, target)
