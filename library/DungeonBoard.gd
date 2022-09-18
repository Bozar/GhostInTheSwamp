extends StateManagerTemplate
# class_name DungeonBoard


const HASH_COLLIDE := "Hashes collide: [%d, %d], %s, %s."

const HASH_TO_SPRITE := {}


func get_by_coord(main_tag: String, coord: IntCoord, layer := 0) -> Sprite:
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag, layer)
	return HASH_TO_SPRITE.get(hash_coord, null)


func add_state(sprite: Sprite, main_tag: String, _sub_tag: String) -> void:
	# Only record sprites inside the dungeon.
	if not main_tag in MainTag.DUNGEON_OBJECT:
		return

	var coord := ConvertCoord.sprite_to_coord(sprite)
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag)
	var current_sprite: Sprite = HASH_TO_SPRITE.get(hash_coord, null)

	if current_sprite != null:
		push_error(HASH_COLLIDE % [coord.x, coord.y, current_sprite.name,
				sprite.name])
		return
	HASH_TO_SPRITE[hash_coord] = sprite


# Refer StateManager.
func remove_state(sprite: Sprite) -> void:
	var store_state := ObjectState.get_state(sprite)
	var coord := ConvertCoord.sprite_to_coord(sprite)
	var main_tag := store_state.main_tag
	var layer := 0
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag, layer)

	HASH_TO_SPRITE.erase(hash_coord)


func remove_all() -> void:
	HASH_TO_SPRITE.clear()


func add_sprite(sprite: Sprite) -> void:
	var store_state := ObjectState.get_state(sprite)
	var main_tag := store_state.main_tag
	var sub_tag := store_state.sub_tag

	add_state(sprite, main_tag, sub_tag)
