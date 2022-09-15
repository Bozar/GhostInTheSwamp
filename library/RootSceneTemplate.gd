extends Node2D
class_name RootSceneTemplate


# "/root/RootScene"
var _path_to_self: String
# [signal_name, func_name, source_node, target_node]
var _signal_bind: Array
# [target_var_name, source_node, target_node]
var _node_ref: Array


func _init(signal_: Array, node_: Array) -> void:
	_signal_bind = signal_
	_node_ref = node_


func _ready() -> void:
	_set_path()
	_set_signal()
	_set_node_ref()


func _set_path() -> void:
	_path_to_self = get_path()


func _set_signal() -> void:
	var signal_name: String
	var signal_sender: String
	var func_name_template := "_on_%s_%s"
	var func_name: String
	var path_to_source: String
	var path_to_target: String

	for s in _signal_bind:
		# [signal_name, signal_sender, source, target_1, target_2, ...]
		signal_name = s[0]
		signal_sender = s[1]
		func_name = func_name_template % [signal_sender, signal_name]
		path_to_source = _get_child_node_path(s[2])
		for i in range(3, s.size()):
			path_to_target = _get_child_node_path(s[i])
			get_node(path_to_source).connect(signal_name,
					get_node(path_to_target), func_name)


func _set_node_ref() -> void:
	var ref_var_name: String
	var path_to_source: String
	var path_to_target: String

	for n in _node_ref:
		ref_var_name = n[0]
		path_to_source = _get_child_node_path(n[1])
		# [ref_var_name, source, target_1, target_2, ...]
		for i in range(2, n.size()):
			path_to_target = _get_child_node_path(n[i])
			get_node(path_to_target)[ref_var_name] = get_node(path_to_source)


func _get_child_node_path(path_to_node: String) -> String:
	return "%s/%s" % [_path_to_self, path_to_node]