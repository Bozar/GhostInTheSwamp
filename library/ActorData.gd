class_name ActorData


const SIGHT_RANGE := {
	SubTag.TOURIST: 1,
	SubTag.SCOUT: 4,
	SubTag.ENGINEER: 1,
	SubTag.PERFORMER: 4,
}

const MIN_WALK_DISTANCE: int = 5
const MIN_DISTANCE_TO_PC: int = 5
const MIN_DISTANCE_TO_ACTOR: int = 3

const MAX_SCOUT: int = 2
const MAX_ENGINEER: int = 2
const MAX_PERFORMER: int = 2
const MAX_ACTOR: int = MAX_SCOUT + MAX_ENGINEER + MAX_PERFORMER
# const MAX_ACTOR: int = 0

const COLLISION_SCORE := {
	SubTag.TOURIST: 0,
	SubTag.SCOUT: 1,
	SubTag.PERFORMER: 2,
	SubTag.ENGINEER: 3,
}

const LOCK_COUNTER: int = 10
const LOCK_THRESHOLD: int = 10
