class_name ArrayHelper


const ELEMENT_WARNING := "rand_picker(): Pick too many elements."
const RAND_WARNING := "rand_picker(): Rand is not of type RandomNumber."


static func rand_picker(source: Array, num_of_element: int, rand) -> void:
	var counter: int

	if num_of_element > source.size():
		push_warning(ELEMENT_WARNING)
	elif not (rand is RandomNumber):
		push_warning(RAND_WARNING)
	else:
		for i in range(num_of_element):
			counter = rand.get_int(i, source.size())
			swap_element(source, i, counter)
		source.resize(num_of_element)


static func shuffle(source: Array, rand) -> void:
	rand_picker(source, source.size(), rand)


# filter_in_func(source: Array, current_index: int, opt_arg: Array) -> bool
# Return true if we need an array element.
static func filter_element(source: Array, func_host: Object,
		filter_in_func: String, opt_arg := []) -> void:
	var filter_in := funcref(func_host, filter_in_func)
	var counter := 0

	for i in range(source.size()):
		if filter_in.call_func(source, i, opt_arg):
			swap_element(source, counter, i)
			counter += 1
	source.resize(counter)


# get_counter_func(source: Array, current_idx: int, opt_arg: Array) -> int
# Return how many times an element should appear in the new array.
static func duplicate_element(source: Array, func_host: Object,
		get_counter_func: String, opt_arg := []) -> void:
	var get_counter := funcref(func_host, get_counter_func)
	var counter: int
	var tmp := []

	for i in range(source.size()):
		counter = get_counter.call_func(source, i, opt_arg) - 1
		for _j in range(counter):
			tmp.push_back(source[i])
	merge(source, tmp)


static func swap_element(source: Array, left_idx: int, right_idx: int) -> void:
	var tmp

	tmp = source[left_idx]
	source[left_idx] = source[right_idx]
	source[right_idx] = tmp


static func merge(source: Array, merge_into_left: Array) -> void:
	var source_size := source.size()
	var merge_size := merge_into_left.size()

	source.resize(source_size + merge_size)
	for i in range(merge_size):
		source[i + source_size] = merge_into_left[i]


static func remove_by_index(source: Array, remove_idx: int) -> void:
	swap_element(source, remove_idx, source.size() - 1)
	source.resize(source.size() - 1)


static func reverse_key_value_in_dict(source_dict: Dictionary,
		reverse_dict: Dictionary) -> void:
	for i in source_dict.keys():
		reverse_dict[source_dict[i]] = i


# reverse_iterate_func(source: Array, current_idx: int, opt_arg: Array) -> int
static func reverse_iterate(source: Array, func_host: Object,
		reverse_iterate_func: String, opt_arg := []) -> void:
	var reverse_iterate := funcref(func_host, reverse_iterate_func)

	for i in range(source.size() - 1, -1, -1):
		reverse_iterate.call_func(source, i, opt_arg)
