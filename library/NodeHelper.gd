extends Node2D
class_name NodeHelper


const WARN_NO_CHILD := "Warn: Parent [%s] has no child node [%s]."
const WARN_PARENT_NO_REF := "Warn: Parent [%s] has no ref var [%s]."


# <path_to_node: String>: <ref_vars: Array>
static func set_child_reference(parent_node: Node, refers: Dictionary) -> void:
	var child_node: Node
	var parent_name := parent_node.name

	for i in refers.keys():
		child_node = parent_node.get_node(i)
		if child_node == null:
			push_warning(WARN_NO_CHILD % [parent_name, i])
			continue
		for ref_var in refers[i]:
			if parent_node.get(ref_var) == null:
				push_warning(WARN_PARENT_NO_REF % [parent_name, ref_var])
				continue
			child_node[ref_var] = parent_node.get(ref_var)
