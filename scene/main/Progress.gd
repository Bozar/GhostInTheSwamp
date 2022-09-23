extends Node2D
class_name Progress


enum {
	GAME_OVER, PLAYER_WIN,
}

signal game_over(win)

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject

var _checkmate_pattern := {
	GAME_OVER: false,
	PLAYER_WIN: false,
}


# Renew game world in-between two turns. Refer: Schedule.
func renew_world(next_actor: Sprite) -> void:
	# Before PC's turn: Respawn actors and buildings (ghosts), update PC state.
	if ObjectState.get_state(next_actor).sub_tag == SubTag.PC:
		$SpawnActor.renew_world()
		# Cast rays to detect surroundings.
		# DirectionTag: {PowerTag, target_sprite}
		# Pass to renew_world() as parameters.
		$StartPcTurn.renew_world()
	else:
		# Cast rays to detect surroundings.
		pass
	# Always check PC and NPC state to decide if game ends.
	$Checkmate.renew_world(_checkmate_pattern)
	if _checkmate_pattern[GAME_OVER]:
		emit_signal(SignalTag.GAME_OVER, _checkmate_pattern[PLAYER_WIN])


# Do not create new sprites here, call renew_world() instead. Refer: Schedule.
func _on_InitWorld_world_initialized() -> void:
	$SpawnActor.set_reference()
	$StartPcTurn.set_reference()

	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var harbor: Sprite = FindObject.get_sprites_with_tag(SubTag.FINAL_HARBOR)[0]
	HarborHelper.toggle_harbor(harbor, true)
