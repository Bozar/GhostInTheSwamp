extends Game_RootNodeTemplate


const INIT_WORLD := "InitWorld"
const PLAYER_INPUT := "PlayerInput"
const HELP_INPUT := "HelpInput"
const ACTOR_ACTION := "ActorAction"
const SCHEDULE := "Schedule"
const DUNGEON := "DungeonBoard"
const CREATE_OBJECT := "CreateObject"
const REMOVE_OBJECT := "RemoveObject"
const RANDOM := "RandomNumber"
const OBJECT_DATA := "ObjectData"
const SWITCH_SPRITE := "SwitchSprite"
const SWITCH_SCREEN := "SwitchScreen"
const END_GAME := "EndGame"
const GAME_PROGRESS := "GameProgress"
const GAME_SETTING := "GameSetting"
const PALETTE := "Palette"
const SIDEBAR_GUI := "MainGUI/SidebarVBox"
const HELP_GUI := "HelpGUI/HelpVScroll"
const DEBUG_GUI := "DebugGUI/DebugVBox"
const DEBUG_INPUT := "DebugInput"

const SIGNAL_BIND := [
	[
		"sprite_created", "_on_CreateObject_sprite_created",
		CREATE_OBJECT,
		SCHEDULE, DUNGEON, OBJECT_DATA,
	],
	[
		"world_initializing", "_on_InitWorld_world_initializing",
		INIT_WORLD,
		GAME_SETTING, PLAYER_INPUT,
	],
	[
		"world_initialized", "_on_InitWorld_world_initialized",
		INIT_WORLD,
		SCHEDULE,
	],
	[
		"world_selected", "_on_InitWorld_world_selected",
		INIT_WORLD,
		SIDEBAR_GUI, HELP_GUI, HELP_INPUT, DEBUG_GUI,
	],
	[
		"turn_starting", "_on_Schedule_turn_starting",
		SCHEDULE,
		GAME_PROGRESS,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		PLAYER_INPUT, ACTOR_ACTION, SIDEBAR_GUI,
	],
	[
		"turn_ending", "_on_Schedule_turn_ending",
		SCHEDULE,
		PLAYER_INPUT,
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		GAME_PROGRESS,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		REMOVE_OBJECT,
		DUNGEON, SCHEDULE, OBJECT_DATA,
	],
	[
		"game_over", "_on_EndGame_game_over",
		END_GAME,
		SCHEDULE, PLAYER_INPUT, SIDEBAR_GUI,
	],
	[
		"setting_loaded", "_on_GameSetting_setting_loaded",
		GAME_SETTING,
		RANDOM, PALETTE,
	],
	[
		"setting_saved", "_on_GameSetting_setting_saved",
		GAME_SETTING,
		RANDOM,
	],
	[
		"screen_switched", "_on_SwitchScreen_screen_switched",
		SWITCH_SCREEN,
		PLAYER_INPUT, CREATE_OBJECT, SIDEBAR_GUI, HELP_INPUT, HELP_GUI,
		DEBUG_GUI, DEBUG_INPUT,
	],
]

const NODE_REF := [
	[
		"_ref_DungeonBoard",
		DUNGEON,
		PLAYER_INPUT, REMOVE_OBJECT, ACTOR_ACTION, GAME_PROGRESS, CREATE_OBJECT,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		PLAYER_INPUT, ACTOR_ACTION, GAME_PROGRESS,
	],
	[
		"_ref_RemoveObject",
		REMOVE_OBJECT,
		PLAYER_INPUT, ACTOR_ACTION, GAME_PROGRESS,
	],
	[
		"_ref_RandomNumber",
		RANDOM,
		INIT_WORLD, PLAYER_INPUT, ACTOR_ACTION, SIDEBAR_GUI, GAME_PROGRESS,
	],
	[
		"_ref_ObjectData",
		OBJECT_DATA,
		ACTOR_ACTION, SWITCH_SPRITE, PLAYER_INPUT, GAME_PROGRESS,
	],
	[
		"_ref_SwitchSprite",
		SWITCH_SPRITE,
		ACTOR_ACTION, PLAYER_INPUT, GAME_PROGRESS,
	],
	[
		"_ref_EndGame",
		END_GAME,
		ACTOR_ACTION, PLAYER_INPUT, GAME_PROGRESS,
	],
	[
		"_ref_CreateObject",
		CREATE_OBJECT,
		INIT_WORLD, GAME_PROGRESS, ACTOR_ACTION, PLAYER_INPUT,
	],
	[
		"_ref_GameSetting",
		GAME_SETTING,
		PLAYER_INPUT, SIDEBAR_GUI, RANDOM, PALETTE,
	],
	[
		"_ref_SwitchScreen",
		SWITCH_SCREEN,
		PLAYER_INPUT, HELP_INPUT, DEBUG_INPUT,
	],
	[
		"_ref_HelpVScroll",
		HELP_GUI,
		HELP_INPUT,
	],
	[
		"_ref_Palette",
		PALETTE,
		PLAYER_INPUT, SIDEBAR_GUI, CREATE_OBJECT, HELP_GUI, ACTOR_ACTION,
		GAME_PROGRESS, DEBUG_GUI,
	],
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
