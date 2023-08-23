# Ghost in the Swamp

## Introduction

### About This Game

Ghost in the Swamp is a turn-based, coffee break Roguelike game made with Godot engine. A successful round takes about 5 to 10 minutes. The source code is available on GitHub. The file icon is downloaded from [Flaticon](https://www.flaticon.com/free-icon/ghost_526076). The GUI font, [Fira Code](https://github.com/tonsky/FiraCode), is created by Nikita Prokopov. The tileset, [curses_vector](http://www.bay12forums.com/smf/index.php?topic=161328.0), is created by DragonDePlatino for Dwarf Fortress. You can play Ghost in the Swamp either locally (which is an executable file) or as an HTML5 game on itch.io.

### Story Background

> The swamp is vast and infinite.

You are the half-ghost guardian of a peaceful swamp. Humans invaded your homeland and stole three precious treasures. You need to spook invaders, retrieve lost items, and finally hide them away in Risky Boots' secret island. You lose the game if you are exposed in human sight without Mana Points, sink in the swamp, or cannot take any valid actions.

### Export the Game

If you want to export Ghost in the Swamp using Godot engine by yourself, first you need to download the project from GitHub. You also have to tweak export settings to filter certain files. In the GitHub repository, refer to `misc/export.md` for more information.

## Key Bindings

General gameplay:

* Move: Arrow keys, Vi keys, ASDW.
* Switch Aim Mode: Space.
* Switch Sight Mode: Tab, Enter, M.
* Exit to Normal Mode: Esc, Ctrl + [.
* Reload after win/lose: Space.
* Quit: Ctrl + W.

Menu keys:

* Open Help menu: C.
* Open Debug menu: V.
* Exit menu: Esc, Ctrl + [.

Function keys:

* Force reload: O.
* Replay dungeon: R.
* Copy RNG seed to clipboard: Ctrl + C.

Following keys are available in Help menu.

* Move down: Down, J, S.
* Move up: Up, K, W.
* Page down: PgDn, Space, F, N.
* Page up: PgUp, B, P.
* Scroll to bottom: End, Shift + G.
* Scroll to top: Home, G.
* Switch to next help: Enter, Right, L, D.
* Switch to previous help: Left, H, A.

Following keys are available in Debug menu. Quote from Godot Docs with slight modification.

* Copy: Ctrl + C.
* Cut: Ctrl + X.
* Paste/"yank": Ctrl + V, Ctrl + Y.
* Undo: Ctrl + Z.
* Redo: Ctrl + Shift + Z.
* Delete text from the cursor position to the beginning of the line: Ctrl + U.
* Delete text from the cursor position to the end of the line: Ctrl + K.
* Select all text: Ctrl + A.
* Move the cursor to the beginning/end of the line: Up/Down arrow.

These keys are available in Wizard Mode (see Game Settings).

* Add 1 Mana Point: 1.
* Raise to full Mana Points: 2.
* Add 1 Ghost: 3.
* Add Rum: Shift + 1.
* Add Parrot: Shift + 2.
* Add Accordion: Shift + 3.
* Teleport to the final island: 4.

## Game World

The game world is composed of terrains (land and swamp) and buildings (harbor and shrub).

A land is represented by a thick dash or a plus symbol. They have no in-game differences. The plus symbol makes it easier for players to measure the distance. A swamp is always shown as a thin dash.

A harbor has five states (see Player Character). Each state has its own symbol. An unlighted harbor is an empty circle, while a lighted one is a solid circle. A closed harbor is an empty or solid triangle. When in Sight Mode, if a closed harbor will become accessible in no more than 9 turns, the triangle is replaced by a number.

A shrub is displayed as a sharp symbol. There is an uppercase letter R in one of the four corners of the dungeon, which is a special shrub. The harbor beside it is your final destination.

## Player Character

### Win & Lose

To beat the game, first you need to collect three items from NPCs (Rum, Parrot & Accordion), then sail to the harbor in a corner of the dungeon (see Game World). You can reach the final destination from one of the two nearby harbors. Before leaving, you need at least 2 and 4 Mana Points respectively.

You lose the game due to one of three reasons. (1) You are seen by an NPC and your Mana Point is less than 1. (2) You spend too much time in swamp and eventually sink. (3) You can neither move in any direction in Normal Mode, nor use any power in Aim Mode.

### Game Modes: Normal, Sight & Aim

Normal Mode is the default game mode. NPCs are shown as uppercase letters (T, S, E & P). PC's symbol depends on his position (see below). Press arrow keys to move one step. You can always press Esc to return to Normal Mode.

Press Tab to switch Sight Mode. PC's symbol remains unchanged. NPCs turn into arrows, which represent their face direction. If an NPC has just been spawned and is not looking anywhere, his symbol is an upside-down question mark. Just like Normal Mode, press arrow keys to move one step.

Press Space to switch Aim Mode. NPCs remain unchanged, while PC turns into a question mark. Press arrow keys to use powers. If there are no powers available, you can do nothing but exit Aim Mode.

### Mana Points & Remaining Ghosts

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

### Move on Land

When in Normal or Sight mode (see above), press arrow keys to move one step. There are, however, a few restrictions. (1) PC cannot move into a grid occupied by an NPC. (2) PC cannot move towards an NPC who can see him. (3) PC cannot enter a harbor unless he has Accordion and the harbor is not closed. (4) PC cannot enter swamp from land unless there is a Dinghy nearby.

Rule 1 is straightforward. Rule 3 and 4 will be elaborated later, which leaves rule 2 to be explained. When PC can be seen by one or more NPCs, the second row in Zone 2 (see above) shows a tip such as `LOS: ← ↓`. LOS refers to line of sight. The directions mean that there is an NPC on your left side and below you. It also means that moving left and downwards is forbidden.

### Enter a Harbor

You can enter or leave a harbor by land or swamp just as moving on land. You are invisible to NPCs when inside a harbor. If you stay in a harbor for one turn or enter the same harbor too frequently, the harbor will be closed and become inaccessible for a few turns (see Game World).

### Enter & Sail in Swamp

You can enter swamp by a Dinghy or a Pirate Ship. When such a watercraft appears, there is a tip in the first row of Zone 2. If he walks away instead of entering swamp, the watercraft disappears the next turn. You are invisible to NPCs when in swamp.

A Dinghy is shown as an exclamation mark. It appears in a random swamp grid that is adjacent to you when Ghost progress bar is full (see above). After boarding a Dinghy, the first row in Zone 2 shows `Ghost`, which means you are obsessed by a ghost.

A Pirate Ship is shown as a double-exclamation mark. It appears in a swamp grid that is adjacent to a harbor. If you enter the harbor from land, the Ship appears in the grid opposing to the land. If you enter from swamp, it appears in your previous position.

When in a Dinghy, PC's symbol is an empty smiling face. He can only sail to a swamp grid that is adjacent to land or a harbor. Sailing time is limited to 4 turns, which is shown in the second row of Zone 2 as `Sink: X-0`. The X decreases by 1 every turn. When it drops to 0, you lose the game because of sinking in swamp.

When in a Pirate Ship, PC's symbol is a solid smiling face. He can move to any swamp grid. The countdown timer is shown as `Sink: X-Y`, where Y equals to current Mana Points. After X drops to 0, you can remain in swamp by consuming Mana Points. You lose if both X and Y are 0.

### Powers 101

All powers must be selected in Aim Mode (see above). All powers, except Land, which appears if you are in swamp, can only be used on land or in a harbor. When in Aim Mode, powers are shown in Zone 3 in the given format: `direction|mana_point_cost: power_name`. Press an arrow key to use a power in the given direction.

### Spook an NPC

PC can Spook an NPC if: (1) They are in a straight line; (2) They are adjacent to each other, or there are only land grids in-between them. The spooked NPC will be removed from game and PC will occupy his position instead. The base Mana Point cost depends on NPC types.

    MP | NPC
    -----------------
    1  | Tourist
    2  | Scout
    4  | Engineer
    4  | Performer

Save MP cost by not Spooking an NPC head-on. Check the target's face direction in Sight Mode.

* -1: Spook an NPC from one side.
* -2: Spook an NPC from behind.

If you are obsessed by a Ghost, MP cost is increased by max(1, number_of_items). The minimum overall cost is 0, but you need at least 1 MP to activate this power.

### Items

As mentioned above, Zone 3 is your inventory in Normal Mode. There are three items (Rum, Parrot & Accordion), which are shown as progress bars initially. Each progress bar has 4 segments. Every time when you Spook an NPC, if the NPC drops an item, the corresponding progress bar increases by 1 or 2 segments. When the progress bar is full, two things happen. One, you unlock an item and gain new powers. Two, all other progress bars lose 1 segment, to a minimum of 0.

* Tourist: No drop.
* Scout: Drop Rum.
* Engineer: Drop Parrot.
* Performer: Drop Accordion.

### Swap Position with an NPC

PC can Swap position with an NPC if: (1) PC has Parrot; (2) PC stands on land; (3) PC and the NPC are in a straight line; (4) There is nothing but continuous swamp in-between them. Swapping costs no Mana Point. It is available even if your MP is below 1.

### Land

You can leave swamp and go back to land if: (1) You are in swamp; (2) You are adjacent to a land grid that is not occupied by an NPC. Landing costs 1 Mana Point if your current MP is greater than 2, otherwise it costs 0 MP.

### Light or Teleport to a Harbor

You can Light a harbor if: (1) You are obsessed by a Ghost; (2) You are adjacent to or inside a harbor. Lighting costs no Mana Point. After that, you restore 1 MP, and are no longer obsessed. If you have Parrot, you can Light a harbor from a distance, which follows the same restrictions as Swapping. You can Teleport to a harbor if you have both Parrot and Accordion. Lighting has a higher priority over Teleporting.

## Non-Player Characters

### Sight Ranges

An NPC can see one or more land grids in a straight line. However, his sight is blocked by swamp or another NPC. Tourists and Engineers can see 1 step ahead. Scouts and Performers can see 4 steps. Performers can also detect PC within 4 steps, and will turn around and move towards PC the next turn. (Therefore it takes Mr Attano's wit to approach them.)

### Respawn

There are at most 6 NPCs at any given time. When an NPC is removed from game, another NPC, who may not be of the same type, respawns the next turn to maintain the population.

Tourists do not respawn after removed. There are always 2 Engineers. If you have fewer than 3 items, there are 2 Scouts and 2 Performers; otherwise there are 4 Performers and no Scouts.

### AI Behaviors

All NPCs repeat the same behavior pattern until they are removed from game:

* Choose a destination.
* Walk towards the destination one step per turn.

An NPC stops moving if PC blocks the path, but he may change face direction.

Engineers always choose the land grid near a harbor as their destinations. They prefer lighted harbors. When they walk past a lighted harbor, they fix the abnormal phenomenon by turning it off.

There are three types of destinations for other NPCs. (1) If an NPC sees PC, PC's current position is the destination. (2) Otherwise, an NPC travels to a crossroad or a dead end, that is, a land connecting 1, 3, or 4 land grids. (3) When PC walks past (i.e. do not use power) such a junction grid, there is a chance that the grid will be chosen by an NPC as his destination. The chance increases as you have more items.

### NPC Collision

When an NPC bumps into another NPC, one of them is removed from game. The collision rules are checked in order as follows:

* Remove the NPC who does not see PC.
* Remove the NPC of lower rank: Engineer > Performer > Scout > Tourist.
* Remove the NPC who is closer to his destination.
* Remove the NPC who is being bumped into.

If an NPC is removed due to collision, you receive a collision debuff to a maximum of 10 stacks. Whenever you can increase Mana Point progress bar (see Player Character), you suffer a progression penalty and one stack of debuff is removed.

## Game Settings

Edit `data/setting.json` for play testing. You can also change settings in debug menu by pressing V. Debug settings overwrite their counterparts in `data/setting.json`. All settings take effect when starting a new game.

When in debug menu, if a text field requires a boolean value, strings match this pattern are true: `^(true|t|yes|y|[1-9]\d*)$`.

Set `rng_seed` to a positive integer as a random number generator seed. When in debug menu, seed digits can be separated by characters: `[-,.\s]`. For example: `12-3,4.56` is the same as `123456`.

Set `wizard_mode` to `true` to enable wizard keys. There will be a plus symbol beside the version number in the lower right corner of the screen, and you will be able to use wizard keys (see Key Bindings).

Set `show_full_map` to `true` to disable fog of war.

Leave `palette` blank to use the default color theme. If you want to use another theme, copy a json file (for example, `blue.json`) from `palette/` to `data/`, and then feed `palette` with a file name with or without the json file extension (both `blue` and `blue.json` works). You can also create your own theme based on `default.json`.

## Appendix: Cheat Sheet

### Key Bindings

* Move: Arrow keys, Vi keys.
* Switch [Aim | Sight] Mode: Space | Tab.
* Quit: Ctrl + W.
* Open [Help | Debug] menu: C | V.
* [Reload | Replay] game: O | R.
* Copy RNG seed to clipboard: Ctrl + C.

### Items

* Rum: Max Mana Point +3.
* Parrot: Swap, Light (ranged), Teleport (requires Accordion).
* Accordion: Enter a harbor, sail a Pirate Ship, Teleport (requires Parrot).

### NPCs

    NPC | Drop      | Sight | Max
    -----------------------------
    T   | -         | 1     | 6
    S   | Rum       | 4     | 2/0
    E   | Parrot    | 1     | 2
    P   | Accordion | 4x4   | 2/4

### Power Costs

    Spook | Condition
    -----------------
    1     | Tourist
    2     | Scout
    4     | Engineer
    4     | Performer
    ====================
    -1    | is_from_side
    -2    | is_from_behind
    +1    | has_ghost && !has_item
    +item | has_ghost && has_item

    Land | Condition
    ----------------
    0    | MP < 3
    1    | MP > 2

### Mana Point

    Harbor | Progress
    -----------------
    1      | 5% (Min reduction)
    2      | 25% (Max reduction)
    3      | 50%
    4      | 80%
    5+     | 115%

### Ghost

    Item | Max Ghosts
    -----------------
    0    | 10
    1+   | 15

    Progress   | Condition
    ----------------------
    +0% to +2% | CONSTANT
    +20%       | MP < 1 | is_in_sight
