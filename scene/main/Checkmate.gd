extends Node2D
class_name Checkmate


func renew_world(out_checkmate_pattern: Dictionary) -> void:
	var pc_state := ObjectState.get_state(FindObject.pc) as PcState
	var pc_coord := ConvertCoord.sprite_to_coord(FindObject.pc)

	if _sink_in_swamp(pc_state) or _is_spotted(pc_state):
		out_checkmate_pattern[Progress.GAME_OVER] = true
		out_checkmate_pattern[Progress.PLAYER_WIN] = false
	elif _reach_final_harbor(pc_state, pc_coord):
		out_checkmate_pattern[Progress.GAME_OVER] = true
		out_checkmate_pattern[Progress.PLAYER_WIN] = true


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
	var low_mp := state.mp < 1
	var has_actor := false

	for i in DirectionTag.VALID_DIRECTIONS:
		if state.is_in_npc_sight(i):
			has_actor = true
			break
	return low_mp and has_actor


func _reach_final_harbor(state: PcState, coord: IntCoord) -> bool:
	return state.has_rum() \
			and state.has_parrot() \
			and state.has_accordion() \
			and FindObjectHelper.has_final_harbor(coord)
