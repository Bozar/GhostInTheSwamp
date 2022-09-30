class_name Checkmate


enum {
	GAME_OVER, PLAYER_WIN,
}


static func renew_world(next_is_pc: bool) -> Dictionary:
	var pc_state := FindObject.pc_state
	var game_over := false
	var player_win := false

	if _sink_in_swamp(pc_state) or _is_spotted(pc_state):
		game_over = true
	elif _reach_final_harbor(pc_state, FindObject.pc_coord):
		game_over = true
		player_win = true
	# PC could be blocked in an NPC's turn, but when his turn starts, he has
	# retored MP to act. So check this only when the next actor is PC.
	elif next_is_pc and (_is_trapped_on_land() or _is_trapped_in_harbor()):
		game_over = true
	return {
		GAME_OVER: game_over,
		PLAYER_WIN: player_win,
	}


static func _sink_in_swamp(state: PcState) -> bool:
	# Ghost dinghy or pirate ship is still intact.
	if state.sail_duration < state.max_sail_duration:
		return false
	# Use MP to support the pirate ship. The ghost ship cannot use MP.
	elif state.use_pirate_ship:
		return state.mp < 1
	return true


static func _is_spotted(state: PcState) -> bool:
	var no_mp := state.mp < 1
	var has_actor := false

	for i in DirectionTag.VALID_DIRECTIONS:
		if state.is_in_npc_sight(i):
			has_actor = true
			break
	return no_mp and has_actor


static func _reach_final_harbor(state: PcState, coord: IntCoord) -> bool:
	return state.has_rum() \
			and state.has_parrot() \
			and state.has_accordion() \
			and FindObjectHelper.has_final_harbor(coord)


static func _is_trapped_on_land() -> bool:
	if not FindObjectHelper.has_land(FindObject.pc_coord):
		return false
	for i in DirectionTag.VALID_DIRECTIONS:
		if FindObject.pc_state.get_power_tag(i) != PowerTag.NO_POWER:
			return false
	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_unoccupied_land(i):
			return false
	return true


static func _is_trapped_in_harbor() -> bool:
	if not FindObjectHelper.has_final_harbor(FindObject.pc_coord):
		return false
	for i in CoordCalculator.get_neighbor(FindObject.pc_coord, 1):
		if FindObjectHelper.has_ship(i):
			return false
		elif FindObjectHelper.has_unoccupied_land(i):
			return false
	return true
