extends Node2D
class_name Schedule


signal turn_started(current_sprite)
signal turn_ended(current_sprite)

var _ref_GameProgress: GameProgress

var _actors := [null]
var _pointer := 0
var _end_game := false
var _remove_actors := []


func end_turn() -> void:
	# The boolean variable _end_game could be set during an actor's turn, or
	# when a turn ends.
	if _end_game:
		_clear_schedule()
		return

	# Do NOT end game when responding to signal `turn_ended`. Use it to clean up
	# data or reset states.
	# print("%s ends turn." % _get_current().name)
	emit_signal(SignalTag.TURN_ENDED, _get_current())
	_goto_next()
	_clear_schedule()

	# Respawn enemies, change terrain or kill PC in-between two turns.
	_ref_GameProgress.renew_world(_get_current())
	_clear_schedule()
	if _end_game:
		return
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


func _on_InitWorld_world_initialized() -> void:
	_ref_GameProgress.renew_world(_get_current())
	emit_signal(SignalTag.TURN_STARTED, _get_current())


func _on_CreateObject_sprite_created(sprite_data: BasicSpriteData) -> void:
	if sprite_data.main_tag == MainTag.ACTOR:
		if sprite_data.sub_tag == SubTag.PC:
			_actors[0] = sprite_data.sprite
		else:
			_actors.append(sprite_data.sprite)


func _on_RemoveObject_sprite_removed(sprite_data: BasicSpriteData) -> void:
	_remove_actors.push_back(sprite_data.sprite)


func _on_EndGame_game_over(_win: bool) -> void:
	_end_game = true


func _get_current() -> Sprite:
	return _actors[_pointer] as Sprite


func _goto_next() -> void:
	_pointer += 1
	if _pointer > _actors.size() - 1:
		_pointer = 0
