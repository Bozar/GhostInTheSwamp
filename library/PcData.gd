class_name PcData


const SIGHT_RANGE := 5

const HIGH_MP := 4
const LOW_MP := 2

const MAX_MP := 3
const MAX_MP_WITH_RUM := 6
const MAX_MP_PROGRESS := 100
const HARBOR_TO_MP_PROGRESS := {
    1: 5,
    2: 25,
    3: 55,
    4: 95,
    5: 145,
}

const MAX_GHOST_PER_ITEM := 20
const MAX_GHOST_TIMER := 100
const TIMER_ADD_PER_TURN := 5
const TIMER_MIN_ADD_PER_TURN := 1
const MIN_RANGE_TO_HARBOR := 5
const TIMER_BONUS_FROM_HARBOR := 10
const TIMER_BONUS_FROM_HIGH_MP := 5
const TIMER_BONUS_FROM_LOW_MP := 10
const TIMER_POSITIVE_OFFSET := 0
const TIMER_NEGATIVE_OFFSET := -10

const MAX_SAIL_DURATION := 5

const COST_LAND_GROUND := 1
const COST_SUB_TAG_TO_SPOOK := {
    SubTag.TOURIST: 1,
    SubTag.SCOUT: 2,
    SubTag.ENGINEER: 4,
    SubTag.PERFORMER: 4,
}
const COST_SPOOK_WITH_TWO_ITEMS := 1
const COST_SPOOK_FROM_BEHIND := 2
const COST_SPOOK_FROM_SIDE := 1
