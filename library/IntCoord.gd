class_name IntCoord


const SET_INT_COORD := "Set IntCoord: %s"

var x: int setget _set_none, get_x
var y: int setget _set_none, get_y


func _init(new_x: int, new_y: int) -> void:
	x = new_x
	y = new_y


func get_x() -> int:
	return x


func get_y() -> int:
	return y


func _set_none(__) -> void:
	push_warning(SET_INT_COORD % String(get_stack()))
