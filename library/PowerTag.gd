class_name PowerTag


enum {
	NO_POWER,
	EMBARK,
	LAND,
	LIGHT,
	PICK,
	SPOOK,
	SWAP,
	TELEPORT,
}

const IS_GHOST_POWER := {
	LIGHT: true,

	EMBARK: false,
	LAND: false,
	PICK: false,
	SPOOK: false,
	SWAP: false,
	TELEPORT: false,
}
