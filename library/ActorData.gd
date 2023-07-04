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

const INITIAL_MAX_ACTOR: int = 5
const INITIAL_SCOUT: int = 2
const INITIAL_ENGINEER: int = 2
const INITIAL_PERFORMER: int = 1
const ADD_ACTOR: int = 1

const COLLISION_SCORE := {
	SubTag.TOURIST: 0,
	SubTag.SCOUT: 1,
	SubTag.PERFORMER: 2,
	SubTag.ENGINEER: 3,
}
