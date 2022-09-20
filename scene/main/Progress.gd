extends Node2D
class_name Progress


signal game_over(win)

var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject

var _game_over := false
var _player_win := true


# Renew game world in-between two turns. Refer: Schedule.
func renew_world(next_actor: Sprite) -> void:
	# Before PC's turn: Respawn actors and buildings (ghosts), update PC state.
	if ObjectState.get_state(next_actor).sub_tag == SubTag.PC:
		$SpawnActor.renew_world()
		$StartPcTurn.renew_world()
	# Always check PC and NPC state to decide if game ends.
	if _game_over:
		emit_signal(SignalTag.GAME_OVER, _player_win)


# Do not create new sprites here, call renew_world() instead. Refer: Schedule.
func _on_InitWorld_world_initialized() -> void:
	$SpawnActor.set_reference()
	$StartPcTurn.set_reference()

	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var island: Sprite = FindObject.get_sprites_by_tag(SubTag.ISLAND)[0]
	var coord := ConvertCoord.sprite_to_coord(island)
	var harbor: Sprite

	for i in CoordCalculator.get_neighbor(coord, 1):
		harbor = FindObject.get_building(i)
		if harbor != null:
			$HarborHelper.toggle_harbor(harbor, true)
			return
