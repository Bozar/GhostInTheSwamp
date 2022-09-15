extends Node2D
class_name EndGame


# 1. Emit this signal when PC's turn has already started, or when it is not PC's
# turn. Otherwies it may conflict with another signal: Schedule.turn_started.
# 2. On the other hand, since the signal could be emitted before a turn ends,
# if a script receives both EndGame.game_over and Schedule.turn_ended, you might
# want to specify that if the game is over, do not respond to
# Schedule.turn_ended.
signal game_over(win)


func player_lose() -> void:
	emit_signal(SignalTag.GAME_OVER, false)


func player_win() -> void:
	emit_signal(SignalTag.GAME_OVER, true)
