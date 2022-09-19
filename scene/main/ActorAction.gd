extends Node2D
class_name ActorAction


var _ref_Schedule: Schedule
var _ref_RandomNumber: RandomNumber
var _ref_RemoveObject: RemoveObject
var _ref_CreateObject: CreateObject


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(SubTag.PC):
		return

	# Take action.
	# print("%s starts turn." % current_sprite.name)
	# Call end_turn early if PC is already dead.
	_ref_Schedule.end_turn()
