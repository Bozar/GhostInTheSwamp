extends Node2D
class_name Game_GameProgress


var _ref_RandomNumber: Game_RandomNumber
var _ref_Schedule: Game_Schedule
var _ref_CreateObject: Game_CreateObject
var _ref_RemoveObject: Game_RemoveObject
var _ref_DungeonBoard: Game_DungeonBoard
var _ref_SwitchSprite: Game_SwitchSprite
var _ref_ObjectData: Game_ObjectData
var _ref_EndGame: Game_EndGame
var _ref_Palette: Game_Palette


func _on_Schedule_turn_starting(_current_sprite: Sprite) -> void:
	pass


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass
