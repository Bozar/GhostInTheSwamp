extends Node2D
class_name RandomNumber


var _rng := RandomNumberGenerator.new()


# Get an integer from min_int (inclusive) to max_int (exclusive).
func get_int(min_int: int, max_int: int) -> int:
	return _rng.randi_range(min_int, max_int - 1)


func get_percent_chance(chance: int) -> bool:
	return chance > get_int(0, 100)


func get_x_coord() -> int:
	return get_int(0, DungeonSize.MAX_X)


func get_y_coord() -> int:
	return get_int(0, DungeonSize.MAX_Y)


func get_dungeon_coord() -> IntCoord:
	return IntCoord.new(get_x_coord(), get_y_coord())


func shuffle(repeat: int) -> void:
	for _i in range(repeat):
		get_int(0, 10)


func get_initial_seed(input_seed: int) -> int:
	var init_seed := input_seed

	while init_seed <= 0:
		_rng.randomize()
		init_seed = _rng.randi()
		if init_seed > 0:
			break

	print("seed: %d" % init_seed)
	_rng.seed = init_seed
	return init_seed
