class_name InputTag
# InputTemplate._verify_input() requires a string tag.


const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
const MOVE_UP := "move_up"
const MOVE_DOWN := "move_down"
const TOGGLE_POWER := "toggle_power"
const CANCEL_POWER := "cancel_power"
const TOGGLE_SIGHT := "toggle_sight"

const RELOAD := "reload"
const FORCE_RELOAD := "force_reload"
const REPLAY_DUNGEON := "replay_dungeon"
const QUIT := "quit"
const COPY_SEED := "copy_seed"

const ANY_WIZARD_KEY := "any_wizard_key"
const ADD_MP := "add_mp"
const FULLY_RESTORE_MP := "fully_restore_mp"
const ADD_GHOST := "add_ghost"
const ADD_RUM := "add_rum"
const ADD_PARROT := "add_parrot"
const ADD_ACCORDION := "add_accordion"

const OPEN_HELP := "open_help"
const OPEN_DEBUG := "open_debug"
const CLOSE_MENU := "close_menu"

const PAGE_DOWN := "page_down"
const PAGE_UP := "page_up"
const SCROLL_TO_TOP := "scroll_to_top"
const SCROLL_TO_BOTTOM := "scroll_to_bottom"
const NEXT_HELP := "next_help"
const PREVIOUS_HELP := "previous_help"

const MOVE_INPUT := [
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
]
const WIZARD_INPUT := [
	ADD_MP,
	FULLY_RESTORE_MP,
	ADD_GHOST,
	ADD_RUM,
	ADD_PARROT,
	ADD_ACCORDION,
]

const INPUT_TO_SPRITE := {
	MOVE_UP: SpriteTypeTag.UP,
	MOVE_DOWN: SpriteTypeTag.DOWN,
	MOVE_LEFT: SpriteTypeTag.LEFT,
	MOVE_RIGHT: SpriteTypeTag.RIGHT,
}


static func get_coord_by_direction(coord: IntCoord, input_tag: String,
		step := 1) -> IntCoord:
	var x_offset := 0
	var y_offset := 0

	match input_tag:
		MOVE_DOWN:
			y_offset = 1
		MOVE_UP:
			y_offset = -1
		MOVE_RIGHT:
			x_offset = 1
		MOVE_LEFT:
			x_offset = -1
		_:
			pass
	return IntCoord.new(coord.x + x_offset * step, coord.y + y_offset * step)
