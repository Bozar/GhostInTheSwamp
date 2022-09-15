extends Node2D
class_name NodeHelper


const WARN_NO_CHILD := "Warn: Parent [%s] has no child node [%s]."
const WARN_PARENT_NO_REF := "Warn: Parent [%s] has no ref var [%s]."

var _parent_node: Node
var _parent_name: String


func _ready() -> void:
	_parent_node = get_parent()
	_parent_name = _parent_node.name


# <path_to_node: String>: <ref_vars: Array>
func set_child_reference(refer_dict: Dictionary) -> void:
	var child_node: Node

	for i in refer_dict.keys():
		child_node = _parent_node.get_node(i)
		if child_node == null:
			push_warning(WARN_NO_CHILD % [_parent_name, i])
			continue
		for ref_var in refer_dict[i]:
			if _parent_node.get(ref_var) == null:
				push_warning(WARN_PARENT_NO_REF % [_parent_name, ref_var])
				continue
			child_node[ref_var] = _parent_node.get(ref_var)
