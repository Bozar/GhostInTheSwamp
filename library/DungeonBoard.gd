extends StateManagerTemplate
# class_name DungeonBoard


const HASH_COLLIDE := "Hashes collide: [%d, %d], %s, %s."

var _hash_to_sprite := {}


func get_by_coord(main_tag: String, coord: IntCoord, layer: int = 0) -> Sprite:
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag, layer)
	return _hash_to_sprite.get(hash_coord, null)


func add_state(sprite: Sprite, main_tag: String, _sub_tag: String) -> void:
	# Only record sprites inside the dungeon.
	if not main_tag in MainTag.DUNGEON_OBJECT:
		return

	var coord := ConvertCoord.sprite_to_coord(sprite)
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag)
	var current_sprite: Sprite = _hash_to_sprite.get(hash_coord, null)

	if current_sprite != null:
		push_error(HASH_COLLIDE % [coord.x, coord.y, current_sprite.name,
				sprite.name])
		return
	_hash_to_sprite[hash_coord] = sprite


# Refer StateManager.
func remove_state(sprite: Sprite) -> void:
	var store_state := ObjectState.get_state(sprite)
	var coord := ConvertCoord.sprite_to_coord(sprite)
	var main_tag := store_state.main_tag
	var layer: int = 0
	var hash_coord := ConvertCoord.hash_coord(coord, main_tag, layer)

	_hash_to_sprite.erase(hash_coord)


func remove_all() -> void:
	_hash_to_sprite.clear()


func add_sprite(sprite: Sprite) -> void:
	var store_state := ObjectState.get_state(sprite)
	var main_tag := store_state.main_tag
	var sub_tag := store_state.sub_tag

	add_state(sprite, main_tag, sub_tag)
