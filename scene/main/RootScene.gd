extends Game_RootSceneTemplate


const SIGNAL_BIND := [
	[
		Game_SignalTag.SPRITE_CREATED, Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.SCHEDULE, Game_NodeTag.DUNGEON, Game_NodeTag.OBJECT_STATE,
	],
	[
		Game_SignalTag.WORLD_INITIALIZED, Game_NodeTag.INIT_WORLD,
		Game_NodeTag.INIT_WORLD,
		Game_NodeTag.SCHEDULE, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.PLAYER_INPUT,
	],
	[
		"world_selected", Game_NodeTag.INIT_WORLD,
		Game_NodeTag.INIT_WORLD,
		Game_NodeTag.HELP_GUI, Game_NodeTag.HELP_INPUT, Game_NodeTag.DEBUG_GUI,
	],
	[
		Game_SignalTag.TURN_STARTED, Game_NodeTag.SCHEDULE,
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.SIDEBAR_GUI,
	],
	[
		Game_SignalTag.TURN_ENDED, Game_NodeTag.SCHEDULE,
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_SignalTag.SPRITE_REMOVED, Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.DUNGEON, Game_NodeTag.SCHEDULE, Game_NodeTag.OBJECT_STATE,
	],
	[
		Game_SignalTag.GAME_OVER, Game_NodeTag.END_GAME,
		Game_NodeTag.END_GAME,
		Game_NodeTag.SCHEDULE, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.SIDEBAR_GUI,
	],
	[
		Game_SignalTag.SETTING_LOADED, Game_NodeTag.GAME_SETTING,
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.RANDOM, Game_NodeTag.PALETTE, Game_NodeTag.SIDEBAR_GUI,
	],
	[
		Game_SignalTag.SETTING_SAVED, Game_NodeTag.GAME_SETTING,
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.RANDOM,
	],
	[
		Game_SignalTag.SCREEN_SWITCHED, Game_NodeTag.SWITCH_SCREEN,
		Game_NodeTag.SWITCH_SCREEN,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.HELP_INPUT,
		Game_NodeTag.HELP_GUI, Game_NodeTag.DEBUG_GUI, Game_NodeTag.DEBUG_INPUT,
	],
	[
		Game_SignalTag.SEED_UPDATED, Game_NodeTag.RANDOM,
		Game_NodeTag.RANDOM,
		Game_NodeTag.GAME_SETTING, Game_NodeTag.SIDEBAR_GUI,
	],
	[
		Game_SignalTag.SPECIAL_KEY, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.SIDEBAR_GUI,
	],
]

const NODE_REF := [
	[
		Game_NodeTag.REF_DUNGEON_BOARD,
		Game_NodeTag.DUNGEON,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.CREATE_OBJECT, Game_NodeTag.INIT_WORLD,
	],
	[
		Game_NodeTag.REF_SCHEDULE,
		Game_NodeTag.SCHEDULE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_NodeTag.REF_REMOVE_OBJECT,
		Game_NodeTag.REMOVE_OBJECT,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.ACTOR_ACTION,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_NodeTag.REF_RANDOM_NUMBER,
		Game_NodeTag.RANDOM,
		Game_NodeTag.INIT_WORLD, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_NodeTag.REF_OBJECT_STATE,
		Game_NodeTag.OBJECT_STATE,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_NodeTag.REF_PC_STATE,
		Game_NodeTag.PC_STATE,
		Game_NodeTag.SIDEBAR_GUI, Game_NodeTag.PLAYER_INPUT,
	],
	[
		Game_NodeTag.REF_END_GAME,
		Game_NodeTag.END_GAME,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
		Game_NodeTag.GAME_PROGRESS,
	],
	[
		Game_NodeTag.REF_CREATE_OBJECT,
		Game_NodeTag.CREATE_OBJECT,
		Game_NodeTag.INIT_WORLD, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.PLAYER_INPUT,
	],
	[
		Game_NodeTag.REF_GAME_SETTING,
		Game_NodeTag.GAME_SETTING,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.INIT_WORLD,
	],
	[
		Game_NodeTag.REF_SWITCH_SCREEN,
		Game_NodeTag.SWITCH_SCREEN,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.HELP_INPUT,
		Game_NodeTag.DEBUG_INPUT,
	],
	[
		Game_NodeTag.REF_HELP_GUI,
		Game_NodeTag.HELP_GUI,
		Game_NodeTag.HELP_INPUT,
	],
	[
		Game_NodeTag.REF_PALETTE,
		Game_NodeTag.PALETTE,
		Game_NodeTag.PLAYER_INPUT, Game_NodeTag.SIDEBAR_GUI,
		Game_NodeTag.CREATE_OBJECT, Game_NodeTag.HELP_GUI,
		Game_NodeTag.ACTOR_ACTION, Game_NodeTag.GAME_PROGRESS,
		Game_NodeTag.DEBUG_GUI,
	],
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
