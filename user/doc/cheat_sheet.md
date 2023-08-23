# Cheat Sheet

[INPUT_HINT]

## Key Bindings

* Move: Arrow keys, Vi keys.
* Switch [Aim | Sight] Mode: Space | Tab.
* Quit: Ctrl + W.
* Open [Help | Debug] menu: C | V.
* [Reload | Replay] game: O | R.
* Copy RNG seed to clipboard: Ctrl + C.

## Items

* Rum: Max Mana Point +3.
* Parrot: Swap, Light (ranged), Teleport (requires Accordion).
* Accordion: Enter a harbor, sail a Pirate Ship, Teleport (requires Parrot).

## NPCs

    NPC | Drop      | Sight | Max
    -----------------------------
    T   | -         | 1     | 6
    S   | Rum       | 4     | 2/0
    E   | Parrot    | 1     | 2
    P   | Accordion | 4x4   | 2/4

## Power Costs

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

## Mana Point

    Harbor | Progress
    -----------------
    1      | 5% (Min reduction)
    2      | 25% (Max reduction)
    3      | 50%
    4      | 80%
    5+     | 115%

## Ghost

    Item | Max Ghosts
    -----------------
    0    | 10
    1+   | 15

    Progress   | Condition
    ----------------------
    +0% to +2% | CONSTANT
    +20%       | MP < 1 | is_in_sight
