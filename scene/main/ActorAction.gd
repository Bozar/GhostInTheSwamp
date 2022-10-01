extends Node2D
class_name ActorAction


var _ref_Schedule: Schedule
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject
var _ref_CreateObject: CreateObject


var _dungeon: Dictionary
var _harbor_states := []
var _harbor_neighbors := {}
var _land_coords := []


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	var state: ActorState

	if current_sprite.is_in_group(SubTag.PC):
		return
	_actor_ai(current_sprite)

	state = ObjectState.get_state(current_sprite)
	if state.remove_self:
		_ref_RemoveObject.remove(current_sprite)
	else:
		ActorSight.toggle_actor(current_sprite, FindObject.pc_state.show_sight)
	_ref_Schedule.end_turn()


func _actor_ai(current_sprite: Sprite) -> void:
	var state: ActorState = ObjectState.get_state(current_sprite)
	var source_coord := state.coord
	var target_coord: IntCoord
	var target_sprite: Sprite

	# Update walk path based on whether PC is in sight.
	if state.detect_pc:
		state.detect_pc = false
		if state.sub_tag != SubTag.ENGINEER:
			_set_path_to_pc(state)
	# Update walk path based on whether actor has reached destination.
	if state.walk_path.size() < 1:
		# Engineer.
		if state.sub_tag == SubTag.ENGINEER:
			# Turn off nearby harbor.
			for i in CoordCalculator.get_neighbor(source_coord, 1):
				if FindObjectHelper.has_harbor(i):
					HarborHelper.toggle_harbor_with_coord(i, false)
					break
			# Update walk path.
			_set_path_to_harbor(state)
			return
		# Tourist, Scout, Performer.
		else:
			_set_path_to_land(state)
			return

	# Decide whether the next grid in the walk path is reachable.
	target_coord = state.walk_path.pop_back()
	if FindObject.has_actor(target_coord):
		# Wait beside PC.
		if CoordCalculator.is_same_coord(target_coord, FindObject.pc_coord):
			state.walk_path.push_back(target_coord)
			return
		# Handle actor collision.
		else:
			# Recored collisions. Reduce MP progress in PcStartTurn.
			FindObject.pc_state.actor_collision += 1
			# Remove an actor.
			target_sprite = FindObject.get_actor(target_coord)
			ActorCollision.set_remove_self(current_sprite, target_sprite)
			if state.remove_self:
				return
			else:
				_ref_RemoveObject.remove(target_sprite)

	state.face_direction = CoordCalculator.get_ray_direction(source_coord,
			target_coord)
	MoveObject.move(current_sprite, target_coord)


func _on_InitWorld_world_initialized() -> void:
	_set_harbor_states()
	_set_coords()


func _set_harbor_states() -> void:
	for i in FindObject.get_sprites_with_tag(SubTag.HARBOR):
		if i.is_in_group(SubTag.FINAL_HARBOR):
			continue
		_harbor_states.push_back(ObjectState.get_state(i))


func _set_coords() -> void:
	var count_neighbor: int

	for coord in FindObjectHelper.get_common_land_coords():
		count_neighbor = 0
		for i in CoordCalculator.get_neighbor(coord, 1):
			if FindObjectHelper.has_land(i):
				count_neighbor += 1
			elif FindObjectHelper.has_harbor(i):
				count_neighbor += 1
				_harbor_neighbors[ConvertCoord.hash_coord(i)] = coord
		# A dead end or a crossroad.
		if count_neighbor != 2:
			_land_coords.push_back(coord)


func _set_path_to_pc(state: ActorState) -> void:
	state.walk_path = ActorWalkPath.get_path(state.last_seen_pc_coord,
			state.coord, _dungeon, _ref_RandomNumber, ActorWalkPath)


func _set_path_to_harbor(actor_state: ActorState) -> void:
	var harbor_state: HarborState
	var hash_coord: int
	var inactive_harbor_neighbors := []
	var active_harbor_neighbors := []
	var land_coord: IntCoord

	for i in _harbor_states:
		harbor_state = i
		hash_coord = ConvertCoord.hash_coord(harbor_state.coord)
		if harbor_state.is_active:
			active_harbor_neighbors.push_back(_harbor_neighbors[hash_coord])
		else:
			inactive_harbor_neighbors.push_back(_harbor_neighbors[hash_coord])
	for coords in [active_harbor_neighbors, inactive_harbor_neighbors]:
		if coords.size() > 0:
			ArrayHelper.shuffle(coords, _ref_RandomNumber)
			land_coord = coords[0]
			break

	actor_state.walk_path = ActorWalkPath.get_path(land_coord, actor_state.coord,
			_dungeon, _ref_RandomNumber, ActorWalkPath)


func _set_path_to_land(actor_state: ActorState) -> void:
	var actor_coord := actor_state.coord
	var next_coord := actor_coord

	while CoordCalculator.is_same_coord(next_coord, actor_coord):
		ArrayHelper.shuffle(_land_coords, _ref_RandomNumber)
		next_coord = _land_coords[0]
	actor_state.walk_path = ActorWalkPath.get_path(next_coord, actor_state.coord,
			_dungeon, _ref_RandomNumber, ActorWalkPath)
