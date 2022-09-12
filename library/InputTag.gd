class_name Game_InputTag
# InputTemplate._verify_input() requires a string tag.


const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
const MOVE_UP := "move_up"
const MOVE_DOWN := "move_down"
const USE_POWER := "use_power"
const TOGGLE_SIGHT := "toggle_sight"

const RELOAD := "reload"
const FORCE_RELOAD := "force_reload"
const REPLAY_DUNGEON := "replay_dungeon"
const QUIT := "quit"

const COPY_SEED := "copy_seed"
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

const DIRECTION_TO_COORD := {
	MOVE_UP: [0, -1],
	MOVE_DOWN: [0, 1],
	MOVE_LEFT: [-1, 0],
	MOVE_RIGHT: [1, 0],
}

const INPUT_TO_SPRITE := {
	MOVE_UP: Game_SpriteTypeTag.UP,
	MOVE_DOWN: Game_SpriteTypeTag.DOWN,
	MOVE_LEFT: Game_SpriteTypeTag.LEFT,
	MOVE_RIGHT: Game_SpriteTypeTag.RIGHT,
}

const INPUT_TO_STATE := {
	MOVE_UP: Game_StateTag.UP,
	MOVE_DOWN: Game_StateTag.DOWN,
	MOVE_LEFT: Game_StateTag.LEFT,
	MOVE_RIGHT: Game_StateTag.RIGHT,
}
