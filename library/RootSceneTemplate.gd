extends Node2D
class_name RootSceneTemplate


enum {
	SOURCE_NODE,
	TARGET_NODE,
	SIGNAL_FUNC,
	REF_VAR,
}
const PATH_TEMPLATE := "%s/%s"

# "/root/RootScene"
var _path_to_self: String
var _signal_bind: Dictionary
var _node_ref: Dictionary


func _init(signal_: Dictionary, node_: Dictionary) -> void:
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
	var signal_data: Dictionary
	var signal_sender: String
	var func_name_template := "_on_%s_%s"
	var func_name: String
	var path_to_sender: String
	var path_to_receiver: String

	# signal_name: {
	#	SOURCE_NODE: sender,
	#	SIGNAL_FUNC: OPTIONAL,
	#	TARGET_NODE: [receiver_1, receiver_2, ...],
	# }
	for s in _signal_bind.keys():
		signal_name = s
		signal_data = _signal_bind[signal_name]
		signal_sender = signal_data[SOURCE_NODE]
		func_name = signal_data.get(SIGNAL_FUNC,
				func_name_template % [signal_sender, signal_name])
		path_to_sender = _get_child_node_path(signal_sender)
		for i in signal_data[TARGET_NODE]:
			path_to_receiver = _get_child_node_path(i)
			get_node(path_to_sender).connect(signal_name,
					get_node(path_to_receiver), func_name)


func _set_node_ref() -> void:
	var source_node: String
	var node_data: Dictionary
	var ref_var_template := "_ref_%s"
	var ref_var_name: String
	var path_to_source: String
	var path_to_target: String

	# source_node: {
	#	REF_VAR: OPTIONAL,
	#	TARGET_NODE: [receiver_1, receiver_2, ...],
	# }
	for n in _node_ref.keys():
		source_node = n
		node_data = _node_ref[source_node]
		path_to_source = _get_child_node_path(source_node)
		ref_var_name = node_data.get(REF_VAR, ref_var_template % source_node)

		for i in node_data[TARGET_NODE]:
			path_to_target = _get_child_node_path(i)
			get_node(path_to_target)[ref_var_name] = get_node(path_to_source)


func _get_child_node_path(path_to_node: String) -> String:
	return PATH_TEMPLATE % [_path_to_self, path_to_node]
