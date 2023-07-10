class_name TernaryLogic


const ERR_INVALID_TERNARY_VALUE := "Cannot convert %d to a Boolean value."

enum {
	FALSE,
	TRUE,
	UNKNOWN,
}


static func convert_to_bool(ternary_value: int) -> bool:
	match ternary_value:
		FALSE:
			return false
		TRUE:
			return true
		_:
			push_error(ERR_INVALID_TERNARY_VALUE % ternary_value)
			return false
