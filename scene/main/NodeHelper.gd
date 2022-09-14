extends Node2D
class_name Game_NodeHelper


const WARN_NO_CHILD := "Warn: Child node [%s] not found."
const WARN_PARENT_NO_REF := "Warn: Ref var [%s] not found in parent."

var _parent_node


func _ready() -> void:
	_parent_node = get_parent()


# <path_to_node: String>: <ref_vars: Array>
func set_child_reference(refer_dict: Dictionary) -> void:
	var child_node: Node2D

	for i in refer_dict.keys():
		child_node = _parent_node.get_node(i)
		if child_node == null:
			push_warning(WARN_NO_CHILD % i)
			continue
		for ref_var in refer_dict[i]:
			if _parent_node.get(ref_var) == null:
				push_warning(WARN_PARENT_NO_REF % ref_var)
				continue
			child_node[ref_var] = _parent_node.get(ref_var)
