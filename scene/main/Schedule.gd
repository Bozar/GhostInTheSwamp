extends Node2D
class_name Schedule


signal turn_started(current_sprite)

var _ref_Progress: Progress

var _actors := [null]
var _pointer := 0
var _remove_actors := []
var _game_over := false


func start_first_turn() -> void:
	_ref_Progress.renew_world(_get_current())
	# Just in case an actor is removed before the very first turn.
	_clear_schedule()
	emit_signal(SignalTag.TURN_STARTED, _get_current())


func end_turn() -> void:
	# print("%s ends turn." % _get_current().name)

	# The pointer may be moved implicitly in _clear_schedule(). So we need to
	# let it point to the next actor in action first.
	_goto_next()
	_clear_schedule()

	# Respawn enemies, change terrain or kill PC in-between two turns. Only end
	# game inside renew_world().
	_ref_Progress.renew_world(_get_current())
	_clear_schedule()
	# Do not start next turn if game is over.
	if _game_over:
		return

	# print("%s starts turn." % _get_current().name)
	emit_signal(SignalTag.TURN_STARTED, _get_current())


func _clear_schedule() -> void:
	var remove_this: Sprite
	var current_actor: Sprite

	while _remove_actors.size() > 0:
		remove_this = _remove_actors.pop_back()
		if remove_this == _get_current():
			_goto_next()
		current_actor = _get_current()

		_actors.erase(remove_this)
		_pointer = _actors.find(current_actor)


func _on_CreateObject_sprite_created(sprite: Sprite) -> void:
	var store_state := ObjectState.get_state(sprite)

	if store_state.main_tag == MainTag.ACTOR:
		if store_state.sub_tag == SubTag.PC:
			_actors[0] = sprite
		else:
			_actors.append(sprite)


func _on_RemoveObject_sprite_removed(sprite: Sprite) -> void:
	_remove_actors.push_back(sprite)


func _on_Progress_game_over(_win: bool) -> void:
	_game_over = true


func _get_current() -> Sprite:
	return _actors[_pointer] as Sprite


func _goto_next() -> void:
	_pointer += 1
	if _pointer > _actors.size() - 1:
		_pointer = 0
