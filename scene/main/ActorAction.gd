extends Node2D
class_name Game_ActorAction


var _ref_Schedule: Game_Schedule
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_EndGame: Game_EndGame
var _ref_RandomNumber: Game_RandomNumber
var _ref_RemoveObject: Game_RemoveObject
var _ref_CreateObject: Game_CreateObject
var _ref_Palette: Game_Palette


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(Game_SubTag.PC):
		return
	# Take action.
	_ref_Schedule.end_turn()
