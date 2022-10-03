class_name PcData


const SIGHT_RANGE := 5

const HIGH_MP := 4
const LOW_MP := 2

const MAX_MP := 3
const MAX_MP_WITH_RUM := 6
const MAX_MP_PROGRESS := 100
const MAX_VALID_HARBOR := 5
const HARBOR_TO_MP_PROGRESS := {
    1: 5,
    2: 25,
    3: 45,
    4: 75,
    5: 105,
}
const MIN_COLLIDE_REDUCTION := 1
const MAX_COLLIDE_REDUCTION := 6

const ITEM_TO_MAX_GHOST := {
    0: 10,
    1: 15,
    2: 15,
    3: 15,
}

const MAX_GHOST_TIMER := 100
const TIMER_ADD_PER_TURN := 5
const TIMER_BONUS_FROM_HARBOR := 10
const TIMER_BONUS_FROM_HIGH_MP := 5
const TIMER_BONUS_FROM_LOW_MP := 10
const TIMER_OFFSET := 6

const MIN_RANGE_TO_HARBOR := 5
const MAX_SAIL_DURATION := 5

const COST_LAND_GROUND := 1
const COST_SUB_TAG_TO_SPOOK := {
    SubTag.TOURIST: 1,
    SubTag.SCOUT: 2,
    SubTag.ENGINEER: 4,
    SubTag.PERFORMER: 4,
}
const COST_GHOST_THRESHOLD := 5
const COST_SPOOK_EXTRA := 1
const COST_SPOOK_FROM_BEHIND := 2
const COST_SPOOK_FROM_SIDE := 1

const ACTOR_TO_TRAP := {
    SubTag.SCOUT: SubTag.RUM,
    SubTag.ENGINEER: SubTag.PARROT,
    SubTag.PERFORMER: SubTag.ACCORDION,
}
const LOW_DROP_SCORE := 20
const HIGH_DROP_SCORE := 41
const MAX_DROP_SCORE := 80
