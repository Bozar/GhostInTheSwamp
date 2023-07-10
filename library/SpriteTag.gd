class_name SpriteTag
# SwitchSprite.set_sprite() requires a string tag.


const DEFAULT := "default"
const ACTIVE := "active"
const LOCKED_DEFAULT := "locked_default"
const LOCKED_ACTIVE := "locked_active"

const USE_POWER := "use_power"
const DEFAULT_HARBOR := "default_harbor"
const ACTIVE_HARBOR := "active_harbor"
const DINGHY := "dinghy"
const SHIP := "ship"

const NO_DIRECTION := "no_direction"
const UP := "up"
const DOWN := "down"
const LEFT := "left"
const RIGHT := "right"

const ZERO := "0"
const ONE := "1"
const TWO := "2"
const THREE := "3"
const FOUR := "4"
const FIVE := "5"
const SIX := "6"
const SEVEN := "7"
const EIGHT := "8"
const NINE := "9"

const ORDERED_SPRITE_TAG := [
	ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE,
]


static func convert_digit_to_tag(digit: int) -> String:
	if (digit > -1) and (digit < ORDERED_SPRITE_TAG.size()):
		return ORDERED_SPRITE_TAG[digit]
	return ZERO
