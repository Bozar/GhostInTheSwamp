extends Node2D
class_name Game_InitWorld


signal world_selected(new_world)
signal world_initializing()
signal world_initialized()

var _ref_RandomNumber: Game_RandomNumber
var _ref_CreateObject: Game_CreateObject

var _world_tag: String
var _world_template: Game_WorldTemplate


func init_world() -> void:
	emit_signal("world_initializing")
	emit_signal("world_selected", "demo")
	_world_template = load("res://library/init/InitDemo.gd").new(self)

	# sb: SpriteBlueprint
	for sb in _world_template.get_blueprint():
		if sb.sub_tag == Game_SubTag.PC:
			_init_indicator(sb.x, sb.y)
		_ref_CreateObject.create_xy(sb.main_tag, sb.sub_tag,
				sb.x, sb.y, sb.sprite_layer)
	_world_template.clear_blueprint()
	emit_signal("world_initialized")


func _init_indicator(x: int, y: int) -> void:
	_ref_CreateObject.create_xy(
			Game_MainTag.INDICATOR, Game_SubTag.ARROW_RIGHT,
			0, y, 0,
			-Game_DungeonSize.ARROW_MARGIN)

	_ref_CreateObject.create_xy(
			Game_MainTag.INDICATOR, Game_SubTag.ARROW_DOWN,
			x, 0, 0,
			0, -Game_DungeonSize.ARROW_MARGIN)

	_ref_CreateObject.create_xy(
			Game_MainTag.INDICATOR, Game_SubTag.ARROW_UP,
			x, Game_DungeonSize.MAX_Y - 1, 0,
			0, Game_DungeonSize.ARROW_MARGIN)
