extends Node2D
class_name ActorAction


var _ref_Schedule: Schedule
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject
var _ref_CreateObject: CreateObject


var _dungeon: Dictionary
var _harbor_sprites := []
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
		if state.sub_tag == SubTag.ENGINEER:
			# Turn off nearby harbor.
			for i in CoordCalculator.get_neighbor(source_coord, 1):
				if FindObjectHelper.has_harbor(i):
					HarborHelper.toggle_harbor_with_coord(i, false)
					break
			# Update walk path.
			_set_path_to_harbor(state)
			return
		else:
			# Update walk path.
			_set_path_to_land(state)
			return

	# Decide whether the next grid in the walk path is reachable.
	target_coord = state.walk_path.pop_back()
	if FindObject.has_actor(target_coord):
		if CoordCalculator.is_same_coord(target_coord, FindObject.pc_coord):
			state.walk_path.push_back(target_coord)
			return
		else:
			# Handle collision.
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
	for i in FindObjectHelper.get_harbors():
		if i.is_in_group(SubTag.FINAL_HARBOR):
			continue
		_harbor_sprites.push_back(i)
	for i in FindObject.get_sprites_with_tag(SubTag.LAND):
		_land_coords.push_back(ConvertCoord.sprite_to_coord(i))


func _set_path_to_pc(state: ActorState) -> void:
	state.walk_path = ActorWalkPath.get_path(state.last_seen_pc_coord,
			state.coord, _dungeon, _ref_RandomNumber, ActorWalkPath)


func _set_path_to_harbor(actor_state: ActorState) -> void:
	var harbor_state: HarborState
	var inactive_harbor_coords := []
	var active_harbor_coords := []
	var land_coord: IntCoord

	for i in _harbor_sprites:
		harbor_state = ObjectState.get_state(i)
		if harbor_state.is_active:
			active_harbor_coords.push_back(harbor_state.coord)
		else:
		# elif CoordCalculator.is_out_of_range(actor_state.coord,
		# 		harbor_state.coord, ActorData.MIN_WALK_DISTANCE):
			inactive_harbor_coords.push_back(harbor_state.coord)
	for coords in [active_harbor_coords, inactive_harbor_coords]:
		if coords.size() > 0:
			ArrayHelper.shuffle(coords, _ref_RandomNumber)
			for i in CoordCalculator.get_neighbor(coords[0], 1):
				if FindObjectHelper.has_land(i):
					land_coord = i
					break
			break

	actor_state.walk_path = ActorWalkPath.get_path(land_coord, actor_state.coord,
			_dungeon, _ref_RandomNumber, ActorWalkPath)


func _set_path_to_land(actor_state: ActorState) -> void:
	ArrayHelper.shuffle(_land_coords, _ref_RandomNumber)
	for i in _land_coords:
		if CoordCalculator.is_out_of_range(i, actor_state.coord,
				ActorData.MIN_WALK_DISTANCE):
			actor_state.walk_path = ActorWalkPath.get_path(i, actor_state.coord,
					_dungeon, _ref_RandomNumber, ActorWalkPath)
			return
