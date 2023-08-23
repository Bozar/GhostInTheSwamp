# Non-Player Characters

[INPUT_HINT]

## Sight Ranges

An NPC can see one or more land grids in a straight line. However, his sight is blocked by swamp or another NPC. Tourists and Engineers can see 1 step ahead. Scouts and Performers can see 4 steps. Performers can also detect PC within 4 steps, and will turn around and move towards PC the next turn. (Therefore it takes Mr Attano's wit to approach them.)

## Respawn

There are at most 6 NPCs at any given time. When an NPC is removed from game, another NPC, who may not be of the same type, respawns the next turn to maintain the population.

Tourists do not respawn after removed. There are always 2 Engineers. If you have fewer than 3 items, there are 2 Scouts and 2 Performers; otherwise there are 4 Performers and no Scouts.

## AI Behaviors

All NPCs repeat the same behavior pattern until they are removed from game:

* Choose a destination.
* Walk towards the destination one step per turn.

An NPC stops moving if PC blocks the path, but he may change face direction.

Engineers always choose the land grid near a harbor as their destinations. They prefer lighted harbors. When they walk past a lighted harbor, they fix the abnormal phenomenon by turning it off.

There are three types of destinations for other NPCs. (1) If an NPC sees PC, PC's current position is the destination. (2) Otherwise, an NPC travels to a crossroad or a dead end, that is, a land connecting 1, 3, or 4 land grids. (3) When PC walks past (i.e. do not use power) such a junction grid, there is a chance that the grid will be chosen by an NPC as his destination. The chance increases as you have more items.

## NPC Collision

When an NPC bumps into another NPC, one of them is removed from game. The collision rules are checked in order as follows:

* Remove the NPC who does not see PC.
* Remove the NPC of lower rank: Engineer > Performer > Scout > Tourist.
* Remove the NPC who is closer to his destination.
* Remove the NPC who is being bumped into.

If an NPC is removed due to collision, you receive a collision debuff to a maximum of 10 stacks. Whenever you can increase Mana Point progress bar (see Player Character), you suffer a progression penalty and one stack of debuff is removed.
