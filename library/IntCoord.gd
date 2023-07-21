class_name IntCoord


var x: int setget _set_none, _get_x
var y: int setget _set_none, _get_y

var _x: int
var _y: int


func _init(x_: int, y_: int) -> void:
	_x = x_
	_y = y_


func _get_x() -> int:
	return _x


func _get_y() -> int:
	return _y


func _set_none(_value) -> void:
	return
