extends Node2D
class_name Progress


signal game_over(win)

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject


# Renew game world in-between two turns. Refer: Schedule.
func renew_world(next_actor: Sprite) -> void:
	var pc_is_on_land := FindObjectHelper.has_land(FindObject.pc_coord)
	var next_actor_is_pc := next_actor.is_in_group(SubTag.PC)
	var cast_results: Dictionary
	var checkmate: Dictionary

	# Always renew world to guarantee that even if game ends (win or lose) after
	# PC's turn, he is shown as refreshed.
	StartPcTurn.renew_world(_ref_RemoveObject)
	# Before PC's turn, respawn actors and set actions in swamp or harbor.
	if next_actor_is_pc:
		$SpawnActor.renew_world()
		StartPcTurn.set_pc_state(_ref_CreateObject)
	# When on land, PC may lose before an NPC's turn due to being spotted.
	if pc_is_on_land:
		# Always set PC state when on land.
		cast_results = CastRay.renew_world(CastRay)
		ActorSight.set_sight_around_pc(cast_results)
		# Set actions on land before PC's turn.
		if next_actor_is_pc:
			SailInSwamp.add_dinghy(_ref_RandomNumber, _ref_CreateObject)
			StartPcTurn.set_movement_outside_swamp()
			MpProgress.renew_world(cast_results, _ref_RandomNumber)
			LandPowerHelper.set_power(cast_results)
	# print(cast_results)

	# Check PC and NPC state to decide if game ends.
	checkmate = Checkmate.renew_world(next_actor_is_pc)
	if checkmate[Checkmate.GAME_OVER]:
		emit_signal(SignalTag.GAME_OVER, checkmate[Checkmate.PLAYER_WIN])


func _on_InitWorld_world_initialized() -> void:
	$SpawnActor.set_reference()

	_active_the_first_harbor()


func _on_RemoveObject_sprite_removed(sprite: Sprite) -> void:
	if sprite.is_in_group(MainTag.ACTOR):
		$SpawnActor.remove_actor(sprite)


func _active_the_first_harbor() -> void:
	var harbor: Sprite = FindObject.get_sprites_with_tag(SubTag.FINAL_HARBOR)[0]
	HarborHelper.toggle_harbor(harbor, true)
