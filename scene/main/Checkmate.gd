extends Node2D
class_name Checkmate


func renew_world(out_checkmate_pattern: Dictionary) -> void:
	var pc_state := FindObject.pc_state
	var game_over := false
	var player_win := false

	if _sink_in_swamp(pc_state) or _is_spotted(pc_state):
		game_over = true
	elif _reach_final_harbor(pc_state, FindObject.pc_coord):
		game_over = true
		player_win = true
	out_checkmate_pattern[Progress.GAME_OVER] = game_over
	out_checkmate_pattern[Progress.PLAYER_WIN] = player_win


func _sink_in_swamp(state: PcState) -> bool:
	# Ghost dinghy or pirate ship is still intact.
	if state.sail_duration < state.max_sail_duration:
		return false
	# Use MP to support the pirate ship.
	if state.has_accordion():
		return state.mp < 1
	# The ghost ship cannot use MP.
	return true


func _is_spotted(state: PcState) -> bool:
	var no_mp := state.mp < 1
	var has_actor := false

	for i in DirectionTag.VALID_DIRECTIONS:
		if state.is_in_npc_sight(i):
			has_actor = true
			break
	return no_mp and has_actor


func _reach_final_harbor(state: PcState, coord: IntCoord) -> bool:
	return state.has_rum() \
			and state.has_parrot() \
			and state.has_accordion() \
			and FindObjectHelper.has_final_harbor(coord)
