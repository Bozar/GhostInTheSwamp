extends BasicSpriteData
class_name HarborState


func _init(_main_tag: String, _sub_tag: String, _sprite: Sprite).(_main_tag,
		_sub_tag, _sprite) -> void:
	is_active = false
	is_locked = false
	_lock_counter = 0


var is_active: bool
var is_locked: bool
var lock_counter: int setget _set_lock_counter, _get_lock_counter

var _lock_counter: int


func _set_lock_counter(value: int) -> void:
	_lock_counter = value

	if _lock_counter > ActorData.LOCK_THRESHOLD:
		is_locked = true
	elif _lock_counter < 1:
		_lock_counter = 0
		is_locked = false


func _get_lock_counter() -> int:
	return _lock_counter
