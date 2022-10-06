class_name ActorData


const SIGHT_RANGE := {
	SubTag.TOURIST: 1,
	SubTag.SCOUT: 4,
	SubTag.ENGINEER: 1,
	SubTag.PERFORMER: 4,
}

const MIN_WALK_DISTANCE := 5
const MIN_DISTANCE_TO_PC := 5
const MIN_DISTANCE_TO_ACTOR := 3

const INITIAL_MAX_ACTOR := 5
const INITIAL_SCOUT := 2
const INITIAL_ENGINEER := 2
const INITIAL_PERFORMER := 1
const ADD_ACTOR := 1

const COLLISION_SCORE := {
	SubTag.TOURIST: 0,
	SubTag.SCOUT: 1,
	SubTag.PERFORMER: 2,
	SubTag.ENGINEER: 3,
}
