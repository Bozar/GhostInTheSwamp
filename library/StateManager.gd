extends StateManagerTemplate
# class_name StateManager
# =====Autoload=====


const ORDERED_FUNC := [
	NodeTag.OBJECT_STATE, NodeTag.DUNGEON_BOARD,
]


# Order matters here. ObjectState should be added first and removed last.
func add_state(sprite: Sprite, main_tag: String, sub_tag: String) -> void:
	for i in ORDERED_FUNC:
		get_tree().root.get_node(i).add_state(sprite, main_tag, sub_tag)


func remove_state(sprite: Sprite) -> void:
	ArrayHelper.reverse_iterate(ORDERED_FUNC, self, "_remove_state", [sprite])


func remove_all() -> void:
	ArrayHelper.reverse_iterate(ORDERED_FUNC, self, "_remove_all")


func _remove_state(source: Array, current_idx: int, opt_arg: Array) -> void:
	var sprite: Sprite = opt_arg[0]
	var node_name: String = source[current_idx]

	get_tree().root.get_node(node_name).remove_state(sprite)


func _remove_all(source: Array, current_idx: int, _opt_arg: Array) -> void:
	var node_name: String = source[current_idx]
	get_tree().root.get_node(node_name).remove_all()
