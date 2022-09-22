extends Node2D
class_name ActorHelper


static func toggle_actor(sprite: Sprite, show_arrow: bool) -> void:
	var state := ObjectState.get_state(sprite) as ActorState
	var new_tag := SpriteTag.DEFAULT

	if show_arrow:
		new_tag = DirectionTag.get_sprite_by_direction(state.face_direction)
	SwitchSprite.set_sprite(sprite, new_tag)
	state.show_arrow = show_arrow
