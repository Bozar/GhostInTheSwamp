extends Node2D
class_name StartPcTurn


const REF_VARS := [
	NodeTag.CREATE_OBJECT,
]

var _ref_CreateObject: CreateObject


func set_reference() -> void:
	NodeHelper.set_child_reference(self, REF_VARS)


func renew_world() -> void:
	var pc := FindObject.pc
	var pc_coord := ConvertCoord.sprite_to_coord(pc)
	var pc_state := ObjectState.get_state(pc)

	# Set PC sprite, add building, set actor fov (PC state), set PC power.
	if FindObject.has_ground_by_sub_tag(pc_coord, SubTag.SWAMP):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.SWAMP)
		_set_power_in_swamp()
	elif FindObject.has_building_by_sub_tag(pc_coord, SubTag.HARBOR):
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.HARBOR)
		_add_ship()
		_set_power_on_harbor()
	# Land
	else:
		_set_pc_sprite(pc, pc_coord, pc_state, SubTag.LAND)
		_add_dinghy()
		_set_actor_fov()
		_set_power_on_land()

	# PC with lower MP has a higher chance to summon a ghost. So add MP at last.
	_set_mp_progress(pc_state)


func _set_mp_progress(pc_state: PcState) -> void:
	var count_harbor := 0

	for i in FindObject.get_sprites_by_tag(SubTag.HARBOR):
		if (ObjectState.get_state(i) as BuildingState).is_active:
			count_harbor += 1
	pc_state.mp_progress += PcData.HARBOR_TO_MP_PROGRESS.get(count_harbor, 0)


func _add_actor() -> void:
	pass


func _add_ship() -> void:
	pass


# Reduce countdown timer until a ghost appears.
func _add_dinghy() -> void:
	pass


func _set_actor_fov() -> void:
	pass


func _set_pc_sprite(pc: Sprite, coord: IntCoord, state: PcState,
		sub_tag: String) -> void:
	var new_sprite := SpriteTag.DEFAULT
	var building: Sprite

	match sub_tag:
		SubTag.HARBOR:
			building = FindObject.get_building_by_sub_tag(coord, SubTag.HARBOR)
			if (ObjectState.get_state(building) as BuildingState).is_active:
				new_sprite = SpriteTag.ACTIVE_HARBOR
			else:
				new_sprite = SpriteTag.DEFAULT_HARBOR
		SubTag.SWAMP:
			if state.has_item(SubTag.ACCORDION):
				new_sprite = SpriteTag.SHIP
			else:
				new_sprite = SpriteTag.DINGHY
		_:
			pass
	SwitchSprite.set_sprite(pc, new_sprite)


func _set_power_in_swamp() -> void:
	pass


func _set_power_on_harbor() -> void:
	pass


func _set_power_on_land() -> void:
	pass
