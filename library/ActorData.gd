class_name ActorData


const SIGHT_RANGE := {
    SubTag.TOURIST: 1,
    SubTag.SCOUT: 4,
    SubTag.ENGINEER: 1,
    SubTag.PERFORMER: 4,
}

const MIN_WALK_DISTANCE := 5

const MAX_ACTOR := 12
const MAX_SCOUT := 4
const MAX_ENGINEER := 4
const MAX_PERFORMER := 4

const COLLISION_SCORE := {
    SubTag.TOURIST: 0,
    SubTag.SCOUT: 1,
    SubTag.PERFORMER: 2,
    SubTag.ENGINEER: 3,
}
const MIN_MP_PROGRESS_REDUCTION := 5
const MAX_MP_PROGRESS_REDUCTION := 11
