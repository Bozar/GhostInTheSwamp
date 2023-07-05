class_name IntCoord


var x: int setget _set_none, get_x
var y: int setget _set_none, get_y

var _x: int
var _y: int


func _init(x_: int, y_: int) -> void:
	_x = x_
	_y = y_


func get_x() -> int:
	return _x


func get_y() -> int:
	return _y


func _set_none(_value) -> void:
	return
