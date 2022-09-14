extends Game_RootSceneTemplate


const SIGNAL_BIND := [
	[
		"sprite_created", "_on_CreateObject_sprite_created",
		Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.SCHEDULE, Game_NodeTag.DUNGEON, Game_NodeTag.OBJECT_STATE,
	],
	[
		"world_initialized", "_on_InitWorld_world_initialized",
		Game_NodeTag.INIT_WORLD,
		Game_NodeTag.SCHEDULE, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.PLAYER_INPUT,
	],
	[
		"world_selected", "_on_InitWorld_world_selected",
		Game_NodeTag.INIT_WORLD,
		Game_NodeTag.HELP_GUI, Game_NodeTag.HELP_INPUT, Game_NodeTag.DEBUG_GUI,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.SIDEBAR_GUI,
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.GAME_PROGRESS,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.DUNGEON, Game_NodeTag.SCHEDULE, Game_NodeTag.OBJECT_STATE,
	],
	[
		"game_over", "_on_EndGame_game_over",
		Game_NodeTag.END_GAME,
		Game_NodeTag.SCHEDULE, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.SIDEBAR_GUI,
	],
	[
		"setting_loaded", "_on_GameSetting_setting_loaded",
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.RANDOM, Game_NodeTag.PALETTE, Game_NodeTag.SIDEBAR_GUI,
	],
	[
		"setting_saved", "_on_GameSetting_setting_saved",
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.RANDOM,
	],
	[
		"screen_switched", "_on_SwitchScreen_screen_switched",
		Game_NodeTag.SWITCH_SCREEN,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.HELP_INPUT,
		Game_NodeTag.HELP_GUI, Game_NodeTag.DEBUG_GUI, Game_NodeTag.DEBUG_INPUT,
	],
	[
		"seed_updated", "_on_RandomNumber_seed_updated",
		Game_NodeTag.RANDOM,
		Game_NodeTag.GAME_SETTING, Game_NodeTag.SIDEBAR_GUI,
	],
	[
		"special_key_pressed", "_on_PlayerInput_special_key_pressed",
		Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.SIDEBAR_GUI,
	],
]

const NODE_REF := [
	[
		"_ref_DungeonBoard",
		Game_NodeTag.DUNGEON,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.CREATE_OBJECT, Game_NodeTag.INIT_WORLD,
	],
	[
		"_ref_Schedule",
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		"_ref_RemoveObject",
		Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		"_ref_RandomNumber",
		Game_NodeTag.RANDOM,
		Game_NodeTag.INIT_WORLD, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
	],
	[
		"_ref_ObjectState",
		Game_NodeTag.OBJECT_STATE,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		"_ref_PcState",
		Game_NodeTag.PC_STATE,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.PLAYER_INPUT,
	],
	[
		"_ref_EndGame",
		Game_NodeTag.END_GAME,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		"_ref_CreateObject",
		Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.INIT_WORLD, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
	],
	[
		"_ref_GameSetting",
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.INIT_WORLD,
	],
	[
		"_ref_SwitchScreen",
		Game_NodeTag.SWITCH_SCREEN,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.HELP_INPUT,
		Game_NodeTag.DEBUG_INPUT,
	],
	[
		"_ref_HelpVScroll",
		Game_NodeTag.HELP_GUI,
		Game_NodeTag.HELP_INPUT,
	],
	[
		"_ref_Palette",
		Game_NodeTag.PALETTE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.SIDEBAR_GUI,
		Game_NodeTag.CREATE_OBJECT, Game_NodeTag.HELP_GUI,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.DEBUG_GUI,
	],
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
