extends Node2D
class_name RandomNumber


const INT_WEIGHT := "Weight must be an integer."

var _rng := RandomNumberGenerator.new()


# Get an integer from min_int (inclusive) to max_int (exclusive).
func get_int(min_int: int, max_int: int) -> int:
	return _rng.randi_range(min_int, max_int - 1)


func get_percent_chance(chance: int) -> bool:
	return chance > get_int(0, 100)


func get_weighted_chance(output_to_weight: Dictionary, default_output):
	var max_weight := 0
	var current_weight := 0
	var this_weight: int
	var output_weight: int

	for i in output_to_weight.values():
		if typeof(i) != TYPE_INT:
			push_error(INT_WEIGHT)
			return default_output
		elif i < 1:
			continue
		max_weight += i

	this_weight = get_int(0, max_weight + 1)
	for i in output_to_weight.keys():
		output_weight = output_to_weight[i]
		if output_weight < 1:
			continue
		current_weight += output_weight
		if this_weight <= current_weight:
			return i
	return default_output


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
