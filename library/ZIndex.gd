class_name ZIndex


const MAIN_TAG_TO_Z_INDEX := {
	MainTag.INVALID: -100,
	MainTag.GROUND: 0,
	MainTag.TRAP: 1,
	MainTag.BUILDING: 2,
	MainTag.ACTOR: 3,
	MainTag.INDICATOR: 4,
}
const LAYERED_MAIN_TAG := [
	MainTag.GROUND,
	MainTag.TRAP,
	MainTag.BUILDING,
	MainTag.ACTOR,
]


static func get_z_index(main_tag: String) -> int:
	if not MAIN_TAG_TO_Z_INDEX.has(main_tag):
		main_tag = MainTag.INVALID
	return MAIN_TAG_TO_Z_INDEX[main_tag]
