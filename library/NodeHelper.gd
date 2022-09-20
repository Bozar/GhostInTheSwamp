extends Node2D
class_name NodeHelper


const PARENT_NO_REF := "Warn: [%s]'s parent has no ref var [%s]."
const CHILD_NO_REF := "Warn: [%s] has no ref var [%s]."

const REF_VAR_PREFIX := "_ref_"


# refers = [node_1, node_2, ...]
static func set_child_reference(self_node: Node, refers: Array) -> void:
	var node_name: String
	var parent_property

	for i in refers:
		if i.begins_with(REF_VAR_PREFIX):
			node_name = i
		else:
			node_name = REF_VAR_PREFIX + i
		parent_property = self_node.get_parent().get(node_name)

		if parent_property == null:
			push_warning(PARENT_NO_REF % [self_node.name, node_name])
		elif not node_name in self_node:
			push_warning(CHILD_NO_REF % [self_node.name, node_name])
		else:
			self_node[node_name] = parent_property
