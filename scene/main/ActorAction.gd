extends Node2D
class_name ActorAction


var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_EndGame: EndGame
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject
var _ref_CreateObject: CreateObject
var _ref_Palette: Palette


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		return
	# Take action.
	_ref_Schedule.end_turn()
