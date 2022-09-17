extends Node2D
class_name StateManagerTemplate


const EMPTY_METHOD := "%s does not implement %s."
const ADD := "add_state()"
const REMOVE := "add_state()"
const REMOVE_ALL := "remove_all()"


func add_state(_sprite_data: BasicSpriteData) -> void:
	push_warning(EMPTY_METHOD % [name, ADD])


func remove_state(_sprite: Sprite) -> void:
	push_warning(EMPTY_METHOD % [name, REMOVE])


func remove_all() -> void:
	push_warning(EMPTY_METHOD % [name, REMOVE_ALL])
