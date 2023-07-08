class_name PcData


const SIGHT_RANGE: int = 5

const LOW_MP: int = 1
const HIGH_MP: int = 4
const MAX_MP: int = 3
const MAX_MP_WITH_RUM: int = 6
const MIN_MP: int = -9

const MAX_MP_PROGRESS: int = 100
const MAX_ACTOR_COLLISION: int = 10
const MAX_INACTIVE_COUNTER: int = 20
const MAX_VALID_HARBOR: int = 5
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

const MAX_GHOST_TIMER: int = 100
const MIN_TIMER_OFFSET: int = 10
const MAX_TIMER_OFFSET: int = 31
const TIMER_BONUS_WHEN_IN_DANGER: int = 20

const MIN_RANGE_TO_HARBOR: int = 5
const MAX_SAIL_DURATION: int = 5

const COST_LAND_GROUND: int = 1
const COST_SUB_TAG_TO_SPOOK := {
	SubTag.TOURIST: 1,
	SubTag.SCOUT: 2,
	SubTag.ENGINEER: 4,
	SubTag.PERFORMER: 4,
}
const COST_SPOOK_EXTRA: int = 1
const COST_SPOOK_FROM_BEHIND: int = 2
const COST_SPOOK_FROM_SIDE: int = 1

const ACTOR_TO_TRAP := {
	SubTag.SCOUT: SubTag.RUM,
	SubTag.ENGINEER: SubTag.PARROT,
	SubTag.PERFORMER: SubTag.ACCORDION,
}
const LOW_DROP_SCORE: int = 20
const HIGH_DROP_SCORE: int = 41
const MAX_DROP_SCORE: int = 80
const MAX_HIT: int = 4
const MAX_ITEM: int = 3
