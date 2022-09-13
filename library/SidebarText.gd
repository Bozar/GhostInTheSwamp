class_name Game_SidebarText


const VERSION := "0.4.4"
# const VERSION := "0.3.1-\nNightly-\n04-16-2021"

const SEPARATOR := "------------\n"
const GAME_OVER := SEPARATOR + "You %s.\n[Space]"
const WIN := "win"
const LOSE := "lose"

const HELP := "Help: C"
const SEED := "{0}-{1}-{2}"

# MP + SEPARATOR + STATE + SEPARATOR + INVENTORY
const STATE_PANEL := "{1}{0}{2}{0}{3}"

# "MP: 3/6|28%"
const MP := "MP: %s/%s|%s%%\n"
# "Ghost\nLOS: → ← ↓ ↑"
const STATE := "%s\n%s\n"
# "Rum\nParrot\nAccordion"
const INVENTORY := "%s\n%s\n%s"

const GHOST := "Ghost"
const LINE_OF_SIGHT := "LOS: %s"
const SINK := "Sink: %s"
const DIRECTION_TO_CHAR := {
    Game_DirectionTag.LEFT: "←",
    Game_DirectionTag.RIGHT: "→",
    Game_DirectionTag.UP: "↑",
    Game_DirectionTag.DOWN: "↓",
}

const SUB_TAG_TO_ITEM := {
    Game_SubTag.RUM: "Rum",
    Game_SubTag.PARROT : "Parrot",
    Game_SubTag.ACCORDION : "Accordion",
}
