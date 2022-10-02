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

const MAX_ACTOR := 6
const MAX_SCOUT := 2
const MAX_ENGINEER := 2
const MAX_PERFORMER := 2

const COLLISION_SCORE := {
    SubTag.TOURIST: 0,
    SubTag.SCOUT: 1,
    SubTag.PERFORMER: 2,
    SubTag.ENGINEER: 3,
}
