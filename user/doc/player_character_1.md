# Player Character: 1/3

[INPUT_HINT]

## Win & Lose

To beat the game, first you need to collect three items from NPCs (Rum, Parrot & Accordion), then sail to the harbor in a corner of the dungeon (see Game World). You can reach the final destination from one of the two nearby harbors. Before leaving, you need at least 2 and 4 Mana Points respectively.

You lose the game due to one of three reasons. (1) You are seen by an NPC and your Mana Point is less than 1. (2) You spend too much time in swamp and eventually sink. (3) You can neither move in any direction in Normal Mode, nor use any power in Aim Mode.

## Game Modes: Normal, Sight & Aim

Normal Mode is the default game mode. NPCs are shown as uppercase letters (T, S, E & P). PC's symbol depends on his position (see below). Press arrow keys to move one step. You can always press Esc to return to Normal Mode.

Press Tab to switch Sight Mode. PC's symbol remains unchanged. NPCs turn into arrows, which represent their face direction. If an NPC has just been spawned and is not looking anywhere, his symbol is an upside-down question mark. Just like Normal Mode, press arrow keys to move one step.

Press Space to switch Aim Mode. NPCs remain unchanged, while PC turns into a question mark. Press arrow keys to use powers. If there are no powers available, you can do nothing but exit Aim Mode.

## Mana Points & Remaining Ghosts

The right side panel is divided into three zones. Zone 1 records Mana Points and remaining Ghosts. Zone 2 shows PC status. In Normal Mode, Zone 3 is inventory; while in Aim Mode, it is your power list.

Mana Points and remaining Ghosts are shown in the given format:

* MP: current_mp/max_mp|progress_bar
* Gh: remaining_ghost|progress_bar

Some powers cost Mana Points, which may reduce your current points to below 0. You have at most 3 MPs initially. The first item in Zone 3, Rum, increases the upper limit to 6. When the MP progress bar reaches 100%, you restore 1 MP. It does NOT increase unless: (1) PC stands on land; (2) PC is in a straight line with an NPC; (3) They are adjacent to each other, or there is nothing but continuous land or swamp in-between them. Note that a mixture of land and swamp does not work.

The MP progress bar increases at most once per turn. It keeps increasing even if your MP is full. The actual amount is increased by the number of lighted harbors, and decreased by NPC collisions (see Non-Player Characters). The decrease is always a random number between 5% and 25%.

    Harbor | Progress
    -----------------
    1      | 5%
    2      | 25%
    3      | 50%
    4      | 80%
    5+     | 115%

Suppose you have Lighted 3 harbors, and there is one NPC collision in the past few turns, the final progression could be: 50% - random(5%, 25%) = 30%. The minimum progression is 0%.

You have 10 remaining Ghosts initially. Obtaining an item for the first time rewards 5 more unused Ghosts. If you are on land and is not obsessed by a Ghost (see below): (1) The Ghost progress bar increases by a tiny amount (0% to 2%) every turn; (2) If PC's MP is below 1 or is in an NPC's sight, the increase receives a constant 20% bonus.

When the progress bar reaches 100%, and there is at least one swamp grid adjacent to you -- the remaining Ghost reduces by 1, and a Dinghy (see below) appears in the swamp. The progress bar does not increase if you have no remaining Ghosts.
