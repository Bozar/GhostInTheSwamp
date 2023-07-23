extends Node2D
class_name ActorAction


var _ref_Schedule: Schedule
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject
var _ref_CreateObject: CreateObject


var _dungeon: Dictionary
var _harbor_states := []
var _harbor_to_neighbor := {}
var _neighbor_to_harbor := {}
var _land_coords := []
var _hash_land_coords := []
var _engineer_end_coords := []
var _alarm_coords := []


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	var state: ActorState

	if current_sprite.is_in_group(SubTag.PC):
		_set_alarm(ObjectState.get_state(current_sprite))
		return
	_actor_ai(current_sprite)

	state = ObjectState.get_state(current_sprite)
	if state.remove_self:
		_ref_RemoveObject.remove(current_sprite)
	else:
		ActorSight.set_sprite(current_sprite)
	_ref_Schedule.end_turn()


func _actor_ai(current_sprite: Sprite) -> void:
	var state: ActorState = ObjectState.get_state(current_sprite)
	var source_coord := state.coord
	var target_coord: IntCoord
	var target_sprite: Sprite

	# Turn off a nearby harbor.
	if state.sub_tag == SubTag.ENGINEER:
		target_coord = _neighbor_to_harbor.get(ConvertCoord.hash_coord(
			source_coord))
		if target_coord != null:
			HarborHelper.set_state_by_coord(target_coord, false)
			HarborHelper.set_sprite_by_coord(target_coord)

	# Update walk path if PC is in sight.
	if state.detect_pc:
		state.detect_pc = false
		if state.sub_tag != SubTag.ENGINEER:
			_set_path_to_pc(state)
	# Update walk path if the actor has reached destination.
	if state.walk_path.size() < 1:
		if state.sub_tag == SubTag.ENGINEER:
			_set_path_to_harbor(state)
		# Tourist, Scout, Performer.
		else:
			_set_path_to_land(state)

	# Decide whether the next grid in the walk path is reachable.
	target_coord = state.walk_path.pop_back()
	state.face_direction = CoordCalculator.get_ray_direction(source_coord,
			target_coord)
	if FindObject.has_actor(target_coord):
		# Wait beside PC.
		if CoordCalculator.is_same_coord(target_coord, FindObject.pc_coord):
			state.walk_path.push_back(target_coord)
			return
		# Handle actor collision.
		else:
			# Recored collisions. Reduce MP progress in MpProgress.
			FindObject.pc_state.actor_collision += 1
			# Remove an actor.
			target_sprite = FindObject.get_actor(target_coord)
			ActorCollision.set_remove_self(current_sprite, target_sprite)
			if state.remove_self:
				return
			else:
				_ref_RemoveObject.remove(target_sprite)
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
				_harbor_to_neighbor[ConvertCoord.hash_coord(i)] = coord
				_neighbor_to_harbor[ConvertCoord.hash_coord(coord)] = i
		# A dead end or a crossroad.
		if count_neighbor != 2:
			_land_coords.push_back(coord)
			_hash_land_coords.push_back(ConvertCoord.hash_coord(coord))
	_hash_land_coords.sort()


func _set_path_to_pc(state: ActorState) -> void:
	state.walk_path = ActorWalkPath.get_path(state.last_seen_pc_coord,
			state.coord, _dungeon, _ref_RandomNumber, ActorWalkPath)


# 1. Prefer active harbors than inactive ones.
# 2. Two engineers rarely reach the same harbor.
func _set_path_to_harbor(actor_state: ActorState) -> void:
	var hash_coord: int
	var active_coords := []
	var coord: IntCoord
	var end_coords := []
	var actor_coord: IntCoord

	# Check if there are active harbors.
	for i in _harbor_states:
		if (i as HarborState).is_active:
			hash_coord = ConvertCoord.hash_coord(i.coord)
			active_coords.push_back(_harbor_to_neighbor[hash_coord])
	if active_coords.size() > 0:
		# Collect end points from engineers.
		for i in FindObject.get_sprites_with_tag(SubTag.ENGINEER):
			coord = (ObjectState.get_state(i) as ActorState).end_point
			if coord != null:
				end_coords.push_back(coord)
		# Make sure that an engineer will reach the active harbor.
		ArrayHelper.shuffle(active_coords, _ref_RandomNumber)
		for i in active_coords:
			# An existing engineer will reach the harbor.
			if _engineer_has_end_coord(i, end_coords):
				continue
			# The current engineer will reach the harbor.
			else:
				_set_engineer_end_coords(i)
				break

	actor_coord = actor_state.coord
	coord = _get_end_coord(actor_coord)
	actor_state.walk_path = ActorWalkPath.get_path(coord, actor_coord,
			_dungeon, _ref_RandomNumber, ActorWalkPath)


func _set_path_to_land(actor_state: ActorState) -> void:
	var actor_coord := actor_state.coord
	var new_coord := actor_coord

	if _alarm_coords.size() > 0:
		new_coord = _alarm_coords.pop_back()
	while CoordCalculator.is_same_coord(new_coord, actor_coord):
		new_coord = ArrayHelper.get_rand_element(_land_coords, _ref_RandomNumber)
	actor_state.walk_path = ActorWalkPath.get_path(new_coord, actor_coord,
			_dungeon, _ref_RandomNumber, ActorWalkPath)


func _engineer_has_end_coord(coord: IntCoord, end_coords: Array) -> bool:
	for i in end_coords:
		if CoordCalculator.is_same_coord(i, coord):
			return true
	return false


func _set_engineer_end_coords(end_point: IntCoord) -> void:
	var this_index: int = -1
	var last_index: int = _engineer_end_coords.size() - 1

	# Break the loop immediately if the last coord is next to an active harbor.
	for i in range(last_index, -1, -1):
		if CoordCalculator.is_same_coord(end_point, _engineer_end_coords[i]):
			this_index = i
			break
	# Swap elements or add an element to make sure that the last coord is next
	# to an active harbor.
	if this_index > -1:
		ArrayHelper.swap_element(_engineer_end_coords, this_index, last_index)
	else:
		_engineer_end_coords.push_back(end_point)


func _get_end_coord(actor_coord: IntCoord) -> IntCoord:
	var end_coord: IntCoord = actor_coord

	while CoordCalculator.is_same_coord(end_coord, actor_coord):
		if _engineer_end_coords.size() < 1:
			_engineer_end_coords = _harbor_to_neighbor.values()
			ArrayHelper.shuffle(_engineer_end_coords, _ref_RandomNumber)
		end_coord = _engineer_end_coords.pop_back()
	return end_coord


func _set_alarm(pc_state: PcState) -> void:
	var pc_coord: IntCoord = pc_state.coord
	var hash_pc_coord: int = ConvertCoord.hash_coord(pc_coord)
	var count_item: int = pc_state.count_item
	var alarm_chance: int

	if not ArrayHelper.has_element_bsearch(_hash_land_coords, hash_pc_coord):
		return
	alarm_chance = PcData.ITEM_TO_ALARM_CHANCE.get(count_item, 0)
	if _ref_RandomNumber.get_percent_chance(alarm_chance):
		_alarm_coords.push_back(pc_coord)
