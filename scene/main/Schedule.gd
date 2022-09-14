extends Node2D
class_name Game_Schedule


signal turn_started(current_sprite)
signal turn_ended(current_sprite)

var _actors := [null]
var _pointer := 0
var _end_game := false
var _end_current_turn := true


func end_turn() -> void:
	# The boolean variable _end_game could be set during an actor's turn, or
	# when a turn ends.
	if _end_game:
		return

	# Suppose NPC X is the currently active actor, and Y is the next one in row.
	# 1. ActorAction calls remove(X).
	# 2. In Schedule, _goto_next() is called and _end_current_turn is set to
	# false.
	# 3. ActorAction calls X.end_turn().
	# 4. In Schedule, we should start Y's turn, rather than ends it.
	if _end_current_turn:
		# print("{0}: End turn.".format([_get_current().name]))
		emit_signal(Game_SignalTag.TURN_ENDED, _get_current())
		if _end_game:
			return
		_goto_next()
	else:
		_end_current_turn = true

	if _end_game:
		return
	emit_signal(Game_SignalTag.TURN_STARTED, _get_current())


func _on_InitWorld_world_initialized() -> void:
	emit_signal(Game_SignalTag.TURN_STARTED, _get_current())


func _on_CreateObject_sprite_created(sprite_data: Game_BasicSpriteData) -> void:
	if sprite_data.main_tag == Game_MainTag.ACTOR:
		if sprite_data.sub_tag == Game_SubTag.PC:
			_actors[0] = sprite_data.sprite
		else:
			_actors.append(sprite_data.sprite)


func _on_RemoveObject_sprite_removed(sprite_data: Game_BasicSpriteData) -> void:
	var current_sprite: Sprite

	if sprite_data.sprite == _get_current():
		_end_current_turn = false
		_goto_next()
	current_sprite = _get_current()

	_actors.erase(sprite_data.sprite)
	_pointer = _actors.find(current_sprite)


func _on_EndGame_game_over(_win: bool) -> void:
	_end_game = true


func _get_current() -> Sprite:
	return _actors[_pointer] as Sprite


func _goto_next() -> void:
	_pointer += 1
	if _pointer > _actors.size() - 1:
		_pointer = 0
