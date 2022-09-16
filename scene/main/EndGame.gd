extends Node2D
class_name EndGame


# These signals could be emitted before a turn ends, so if a script receives
# both EndGame.game_over and Schedule.turn_ended, you might want to specify that
# if the game is over, do not respond to Schedule.turn_ended.
signal game_over(win)


func player_lose() -> void:
	emit_signal(SignalTag.GAME_OVER, false)


func player_win() -> void:
	emit_signal(SignalTag.GAME_OVER, true)
