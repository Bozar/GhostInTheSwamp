extends RootSceneTemplate


const SIGNAL_BIND := [
	[
		SignalTag.SPRITE_CREATED, NodeTag.CREATE_OBJECT,
		NodeTag.SCHEDULE,
	],
	[
		SignalTag.WORLD_INITIALIZED, NodeTag.INIT_WORLD,
		NodeTag.PROGRESS, NodeTag.SIDEBAR_GUI, NodeTag.PLAYER_INPUT,
		NodeTag.SCHEDULE, NodeTag.DEBUG_GUI,
	],
	[
		"world_selected", NodeTag.INIT_WORLD,
		NodeTag.HELP_GUI, NodeTag.HELP_INPUT,
	],
	[
		SignalTag.TURN_STARTED, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.SIDEBAR_GUI,
	],
	[
		SignalTag.TURN_ENDED, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT,
	],
	[
		SignalTag.SPRITE_REMOVED, NodeTag.REMOVE_OBJECT,
		NodeTag.SCHEDULE,
	],
	[
		SignalTag.GAME_OVER, NodeTag.END_GAME,
		NodeTag.SCHEDULE, NodeTag.PLAYER_INPUT, NodeTag.SIDEBAR_GUI,
	],
	[
		SignalTag.SETTING_LOADED, NodeTag.SETTING,
		NodeTag.PALETTE, NodeTag.DEBUG_GUI,
	],
	[
		SignalTag.SETTING_SAVED, NodeTag.SETTING,
		NodeTag.DEBUG_GUI,
	],
	[
		SignalTag.SCREEN_SWITCHED, NodeTag.SWITCH_SCREEN,
		NodeTag.PLAYER_INPUT, NodeTag.CREATE_OBJECT, NodeTag.SIDEBAR_GUI,
		NodeTag.HELP_INPUT, NodeTag.HELP_GUI, NodeTag.DEBUG_GUI,
		NodeTag.DEBUG_INPUT,
	],
	[
		SignalTag.SPECIAL_KEY, NodeTag.PLAYER_INPUT,
		NodeTag.SIDEBAR_GUI,
	],
]

const NODE_REF := [
	[
		NodeTag.REF_SCHEDULE, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION,
	],
	[
		NodeTag.REF_PROGRESS, NodeTag.PROGRESS,
		NodeTag.SCHEDULE,
	],
	[
		NodeTag.REF_REMOVE_OBJECT, NodeTag.REMOVE_OBJECT,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.PROGRESS,
	],
	[
		NodeTag.REF_RANDOM_NUMBER, NodeTag.RANDOM,
		NodeTag.INIT_WORLD, NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION,
		NodeTag.PROGRESS, NodeTag.SETTING,
	],
	[
		NodeTag.REF_END_GAME, NodeTag.END_GAME,
		NodeTag.ACTOR_ACTION, NodeTag.PLAYER_INPUT, NodeTag.PROGRESS,
	],
	[
		NodeTag.REF_CREATE_OBJECT, NodeTag.CREATE_OBJECT,
		NodeTag.INIT_WORLD, NodeTag.PROGRESS, NodeTag.ACTOR_ACTION,
		NodeTag.PLAYER_INPUT,
	],
	[
		NodeTag.REF_SETTING, NodeTag.SETTING,
		NodeTag.PLAYER_INPUT, NodeTag.INIT_WORLD,
	],
	[
		NodeTag.REF_SWITCH_SCREEN, NodeTag.SWITCH_SCREEN,
		NodeTag.PLAYER_INPUT, NodeTag.HELP_INPUT, NodeTag.DEBUG_INPUT,
	],
	[
		NodeTag.REF_HELP_GUI, NodeTag.HELP_GUI,
		NodeTag.HELP_INPUT,
	],
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
