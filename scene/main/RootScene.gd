extends RootSceneTemplate


const SIGNAL_BIND := [
	[
		SignalTag.SPRITE_CREATED, NodeTag.CREATE_OBJECT,
		NodeTag.SCHEDULE, NodeTag.INIT_WORLD,
	],
	[
		SignalTag.WORLD_INITIALIZED, NodeTag.INIT_WORLD,
		NodeTag.SCHEDULE, NodeTag.PROGRESS, NodeTag.SIDEBAR_GUI,
		NodeTag.PLAYER_INPUT,
	],
	[
		"world_selected", NodeTag.INIT_WORLD,
		NodeTag.HELP_GUI, NodeTag.HELP_INPUT, NodeTag.DEBUG_GUI,
	],
	[
		SignalTag.TURN_STARTED, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.SIDEBAR_GUI,
	],
	[
		SignalTag.TURN_ENDED, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT, NodeTag.PROGRESS,
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
		NodeTag.RANDOM, NodeTag.PALETTE, NodeTag.SIDEBAR_GUI,
	],
	[
		SignalTag.SETTING_SAVED, NodeTag.SETTING,
		NodeTag.RANDOM,
	],
	[
		SignalTag.SCREEN_SWITCHED, NodeTag.SWITCH_SCREEN,
		NodeTag.PLAYER_INPUT, NodeTag.CREATE_OBJECT, NodeTag.SIDEBAR_GUI,
		NodeTag.HELP_INPUT, NodeTag.HELP_GUI, NodeTag.DEBUG_GUI,
		NodeTag.DEBUG_INPUT,
	],
	[
		SignalTag.SEED_UPDATED, NodeTag.RANDOM,
		NodeTag.SETTING, NodeTag.SIDEBAR_GUI,
	],
	[
		SignalTag.SPECIAL_KEY, NodeTag.PLAYER_INPUT,
		NodeTag.SIDEBAR_GUI,
	],
]

const NODE_REF := [
	[
		NodeTag.REF_SCHEDULE, NodeTag.SCHEDULE,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.PROGRESS,
	],
	[
		NodeTag.REF_REMOVE_OBJECT, NodeTag.REMOVE_OBJECT,
		NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.PROGRESS,
	],
	[
		NodeTag.REF_RANDOM_NUMBER, NodeTag.RANDOM,
		NodeTag.INIT_WORLD, NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION,
		NodeTag.PROGRESS,
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
	[
		NodeTag.REF_PALETTE, NodeTag.PALETTE,
		NodeTag.PLAYER_INPUT, NodeTag.SIDEBAR_GUI, NodeTag.CREATE_OBJECT,
		NodeTag.HELP_GUI, NodeTag.ACTOR_ACTION, NodeTag.PROGRESS,
		NodeTag.DEBUG_GUI,
	],
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
