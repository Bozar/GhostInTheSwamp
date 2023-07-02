extends RootSceneTemplate


const SIGNAL_BIND := {
	SignalTag.SPRITE_CREATED: {
		SOURCE_NODE: NodeTag.CREATE_OBJECT,
		TARGET_NODE: [
			NodeTag.SCHEDULE,
		],
	},
	SignalTag.WORLD_INITIALIZED: {
		SOURCE_NODE: NodeTag.INIT_WORLD,
		TARGET_NODE: [
			NodeTag.PROGRESS, NodeTag.SIDEBAR_GUI, NodeTag.PLAYER_INPUT,
			NodeTag.DEBUG_GUI, NodeTag.ACTOR_ACTION,
		],
	},
	"world_selected": {
		SOURCE_NODE: NodeTag.INIT_WORLD,
		TARGET_NODE: [
			NodeTag.HELP_GUI, NodeTag.HELP_INPUT,
		],
	},
	SignalTag.TURN_STARTED: {
		SOURCE_NODE: NodeTag.SCHEDULE,
		TARGET_NODE: [
			NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.SIDEBAR_GUI,
		],
	},
	SignalTag.SPRITE_REMOVED: {
		SOURCE_NODE: NodeTag.REMOVE_OBJECT,
		TARGET_NODE: [
			NodeTag.SCHEDULE, NodeTag.PROGRESS,
		],
	},
	SignalTag.GAME_OVER: {
		SOURCE_NODE: NodeTag.PROGRESS,
		TARGET_NODE: [
			NodeTag.PLAYER_INPUT, NodeTag.SIDEBAR_GUI, NodeTag.SCHEDULE,
		],
	},
	SignalTag.SETTING_LOADED: {
		SOURCE_NODE: NodeTag.SETTING,
		TARGET_NODE: [
			NodeTag.PALETTE, NodeTag.DEBUG_GUI,
		],
	},
	SignalTag.SETTING_SAVED: {
		SOURCE_NODE: NodeTag.SETTING,
		TARGET_NODE: [
			NodeTag.DEBUG_GUI,
		],
	},
	SignalTag.SCREEN_SWITCHED: {
		SOURCE_NODE: NodeTag.SWITCH_SCREEN,
		TARGET_NODE: [
			NodeTag.PLAYER_INPUT, NodeTag.CREATE_OBJECT, NodeTag.SIDEBAR_GUI,
			NodeTag.HELP_INPUT, NodeTag.HELP_GUI, NodeTag.DEBUG_GUI,
			NodeTag.DEBUG_INPUT,
		],
	},
	SignalTag.SPECIAL_KEY: {
		SOURCE_NODE: NodeTag.PLAYER_INPUT,
		TARGET_NODE: [
			NodeTag.SIDEBAR_GUI,
		],
	},
}

const NODE_REF := {
	NodeTag.SCHEDULE: {
		TARGET_NODE: [
			NodeTag.PLAYER_INPUT, NodeTag.ACTOR_ACTION, NodeTag.INIT_WORLD,
		],
	},
	NodeTag.PROGRESS: {
		TARGET_NODE: [
			NodeTag.SCHEDULE,
		],
	},
	NodeTag.REMOVE_OBJECT: {
		TARGET_NODE: [
			NodeTag.ACTOR_ACTION, NodeTag.PROGRESS, NodeTag.PC_ACTION,
		],
	},
	NodeTag.RANDOM_NUMBER: {
		TARGET_NODE: [
			NodeTag.INIT_WORLD, NodeTag.ACTOR_ACTION, NodeTag.PROGRESS,
			NodeTag.SETTING, NodeTag.INIT_WORLD_HELPER, NodeTag.PC_ACTION,
			NodeTag.SPAWN_ACTOR,
		],
	},
	NodeTag.CREATE_OBJECT: {
		TARGET_NODE: [
			NodeTag.INIT_WORLD, NodeTag.PROGRESS, NodeTag.ACTOR_ACTION,
			NodeTag.INIT_WORLD_HELPER, NodeTag.PC_ACTION, NodeTag.SPAWN_ACTOR,
		],
	},
	NodeTag.SETTING: {
		TARGET_NODE: [
			NodeTag.INIT_WORLD, NodeTag.PLAYER_INPUT,
		],
	},
	NodeTag.SWITCH_SCREEN: {
		TARGET_NODE: [
			NodeTag.PLAYER_INPUT, NodeTag.HELP_INPUT, NodeTag.DEBUG_INPUT,
		],
	},
	NodeTag.HELP_GUI: {
		REF_VAR: NodeTag.REF_HELP_GUI,
		TARGET_NODE: [
			NodeTag.HELP_INPUT,
		],
	},
}


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	return
