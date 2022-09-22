class_name SidebarText


const VERSION := "%s0.4.4"
# const VERSION := "0.3.1-\nNightly-\n04-16-2021"
const WIZARD := "+"

const SEPARATOR := "------------\n"
const GAME_OVER := "%s\n" + SEPARATOR + "You %s.\n[Space]"
const WIN := "win"
const LOSE := "lose"

const HELP := "Help: C"
const SEED := "%s-%s-%s"

# MP + GHOST_COUNT + SEPARATOR + STATE + SEPARATOR + INVENTORY
const STATE_PANEL := "{1}{2}{0}{3}{0}{4}"

# MP: 3/6|28%
const MP := "MP: %s/%s|%s%%\n"
# Ghost: 12/20
const GHOST_COUNT := "Gh: %d/%d\n"
# Ghost\n[LOS: → ← ↓ ↑ | Sink: 3-5]
const STATE := "%s\n%s\n"
# Rum\nParrot\nAccordion
const INVENTORY := "%s\n%s\n%s"

const GHOST := "Ghost"
const DINGHY := "Dinghy"
const SHIP := "Ship"
const GHOST_SHIP := "Ghost|Ship"
# Arrow Dinghy | Ship | Ghost\|Ship
const EMBARK := "%s %s"
const LINE_OF_SIGHT := "LOS: %s"
const SINK := "Sink: %d-%d"
const DIRECTION_TO_CHAR := {
    DirectionTag.LEFT: "←",
    DirectionTag.RIGHT: "→",
    DirectionTag.UP: "↑",
    DirectionTag.DOWN: "↓",
}

const SUB_TAG_TO_ITEM := {
    SubTag.RUM: "Rum",
    SubTag.PARROT : "Parrot",
    SubTag.ACCORDION : "Accordion",
}

const POWER_TAG_TO_NAME := {
    PowerTag.EMBARK: "Embark",
	PowerTag.LAND: "Land",
	PowerTag.LIGHT: "Light",
	PowerTag.PICK: "Pick",
	PowerTag.SPOOK: "Spook",
	PowerTag.SWAP: "Swap",
}
const POWER_TEMPLATE := "%s|%s: %s\n"
const LAST_POWER := "_|0: Exit"
