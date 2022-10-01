class_name InputTag
# InputTemplate._verify_input() requires a string tag.


const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
const MOVE_UP := "move_up"
const MOVE_DOWN := "move_down"
const TOGGLE_POWER_MODE := "toggle_power_mode"
const EXIT_POWER_MODE := "exit_power_mode"
const TOGGLE_SIGHT_MODE := "toggle_sight_mode"
const EXIT_SIGHT_MODE := "exit_sight_mode"

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
const DEV_KEY := "dev_key"

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
	ADD_RUM,
	ADD_PARROT,
	ADD_ACCORDION,
	ADD_MP,
	FULLY_RESTORE_MP,
	ADD_GHOST,
	DEV_KEY,
]

const INPUT_TO_SPRITE := {
	MOVE_UP: SpriteTag.UP,
	MOVE_DOWN: SpriteTag.DOWN,
	MOVE_LEFT: SpriteTag.LEFT,
	MOVE_RIGHT: SpriteTag.RIGHT,
}
const INPUT_TO_DIRECTION := {
	MOVE_UP: DirectionTag.UP,
	MOVE_DOWN: DirectionTag.DOWN,
	MOVE_LEFT: DirectionTag.LEFT,
	MOVE_RIGHT: DirectionTag.RIGHT,
}


static func get_sprite_tag(input_tag: String) -> String:
	return INPUT_TO_SPRITE.get(input_tag, SpriteTag.DEFAULT)


static func get_direction_tag(input_tag: String) -> int:
	return INPUT_TO_DIRECTION.get(input_tag, DirectionTag.NO_DIRECTION)


static func get_coord_by_direction(coord: IntCoord, input_tag: String,
		step := 1) -> IntCoord:
	var direction := get_direction_tag(input_tag)
	return CoordCalculator.get_coord_by_direction(coord, direction, step)
