extends Node2D
class_name GameProgress


var _ref_RandomNumber: RandomNumber
var _ref_CreateObject: CreateObject
var _ref_RemoveObject: RemoveObject

var _ref_Schedule: Schedule
var _ref_EndGame: EndGame
var _ref_Palette: Palette


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass


func _on_InitWorld_world_initialized() -> void:
	_active_the_first_harbor()


func _active_the_first_harbor() -> void:
	var island: Sprite = $FindObject.get_sprites_by_tag(SubTag.ISLAND)[0]
	var coord := ConvertCoord.sprite_to_coord(island)
	var harbor: Sprite

	for i in CoordCalculator.get_neighbor(coord, 1):
		if $FindObject.has_sprite(MainTag.BUILDING, i):
			harbor = $FindObject.get_sprite(MainTag.BUILDING, i)
			$HarborHelper.toggle_harbor(harbor, true)
			return
