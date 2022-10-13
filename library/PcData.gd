class_name PcData


const SIGHT_RANGE := 5

const LOW_MP := 1
const HIGH_MP := 4
const MAX_MP := 3
const MAX_MP_WITH_RUM := 6

const MAX_MP_PROGRESS := 100
const MAX_ACTOR_COLLISION := 10
const MAX_VALID_HARBOR := 5
const HARBOR_TO_MP_PROGRESS := {
	1: 5,
	2: 25,
	3: 50,
	4: 80,
	5: 115,
}

const ITEM_TO_MAX_GHOST := {
	0: 10,
	1: 15,
	2: 20,
	3: 20,
}

const MAX_GHOST_TIMER := 100
const MIN_TIMER_OFFSET := 5
const MAX_TIMER_OFFSET := 16
const TIMER_BONUS_WHEN_IN_DANGER := 20

const MIN_RANGE_TO_HARBOR := 5
const MAX_SAIL_DURATION := 5

const COST_LAND_GROUND := 1
const COST_SUB_TAG_TO_SPOOK := {
	SubTag.TOURIST: 1,
	SubTag.SCOUT: 2,
	SubTag.ENGINEER: 4,
	SubTag.PERFORMER: 4,
}
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
const MAX_HIT := 4
