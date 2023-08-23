# Player Character: 2/3

[INPUT_HINT]

## Move on Land

When in Normal or Sight mode (see above), press arrow keys to move one step. There are, however, a few restrictions. (1) PC cannot move into a grid occupied by an NPC. (2) PC cannot move towards an NPC who can see him. (3) PC cannot enter a harbor unless he has Accordion and the harbor is not closed. (4) PC cannot enter swamp from land unless there is a Dinghy nearby.

Rule 1 is straightforward. Rule 3 and 4 will be elaborated later, which leaves rule 2 to be explained. When PC can be seen by one or more NPCs, the second row in Zone 2 (see above) shows a tip such as `LOS: ← ↓`. LOS refers to line of sight. The directions mean that there is an NPC on your left side and below you. It also means that moving left and downwards is forbidden.

## Enter a Harbor

You can enter or leave a harbor by land or swamp just as moving on land. You are invisible to NPCs when inside a harbor. If you stay in a harbor for one turn or enter the same harbor too frequently, the harbor will be closed and become inaccessible for a few turns (see Game World).

## Enter & Sail in Swamp

You can enter swamp by a Dinghy or a Pirate Ship. When such a watercraft appears, there is a tip in the first row of Zone 2. If he walks away instead of entering swamp, the watercraft disappears the next turn. You are invisible to NPCs when in swamp.

A Dinghy is shown as an exclamation mark. It appears in a random swamp grid that is adjacent to you when Ghost progress bar is full (see above). After boarding a Dinghy, the first row in Zone 2 shows `Ghost`, which means you are obsessed by a ghost.

A Pirate Ship is shown as a double-exclamation mark. It appears in a swamp grid that is adjacent to a harbor. If you enter the harbor from land, the Ship appears in the grid opposing to the land. If you enter from swamp, it appears in your previous position.

When in a Dinghy, PC's symbol is an empty smiling face. He can only sail to a swamp grid that is adjacent to land or a harbor. Sailing time is limited to 4 turns, which is shown in the second row of Zone 2 as `Sink: X-0`. The X decreases by 1 every turn. When it drops to 0, you lose the game because of sinking in swamp.

When in a Pirate Ship, PC's symbol is a solid smiling face. He can move to any swamp grid. The countdown timer is shown as `Sink: X-Y`, where Y equals to current Mana Points. After X drops to 0, you can remain in swamp by consuming Mana Points. You lose if both X and Y are 0.
