extends Node2D
class_name GameProgress


var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject
var _ref_EndGame: EndGame


# Renew game world in-between two turns.
# _ref_EndGame.call_deferred("player_win")
func renew_world(next_actor: Sprite) -> void:
	if ObjectState.get_state(next_actor).sub_tag == SubTag.PC:
		$StartPcTurn.renew_world()


# Do not create new sprites here, call `renew_world()` instead. Refer: Schedule.
func _on_InitWorld_world_initialized() -> void:
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
