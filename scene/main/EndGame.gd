extends Node2D
class_name EndGame


const PATH_TO_ROOT := "res://scene/main/RootScene.tscn"

# These signals could be emitted before a turn ends, so if a script receives
# both EndGame.game_over and Schedule.turn_ended, you might want to specify that
# if the game is over, do not respond to Schedule.turn_ended.
signal game_over(win)


func player_lose() -> void:
	emit_signal(SignalTag.GAME_OVER, false)


func player_win() -> void:
	emit_signal(SignalTag.GAME_OVER, true)


func quit() -> void:
	StateManager.remove_all()
	get_tree().quit()


func reload() -> void:
	var new_scene: Node2D = load(PATH_TO_ROOT).instance()
	var old_scene: Node2D = get_tree().current_scene

	StateManager.remove_all()

	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

	get_tree().root.remove_child(old_scene)
	old_scene.queue_free()
