# Player Character: 3/3

[INPUT_HINT]

## Powers 101

All powers must be selected in Aim Mode (see above). All powers, except Land, which appears if you are in swamp, can only be used on land or in a harbor. When in Aim Mode, powers are shown in Zone 3 in the given format: `direction|mana_point_cost: power_name`. Press an arrow key to use a power in the given direction.

## Spook an NPC

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

## Items

As mentioned above, Zone 3 is your inventory in Normal Mode. There are three items (Rum, Parrot & Accordion), which are shown as progress bars initially. Each progress bar has 4 segments. Every time when you Spook an NPC, if the NPC drops an item, the corresponding progress bar increases by 1 or 2 segments. When the progress bar is full, two things happen. One, you unlock an item and gain new powers. Two, all other progress bars lose 1 segment, to a minimum of 0.

* Tourist: No drop.
* Scout: Drop Rum.
* Engineer: Drop Parrot.
* Performer: Drop Accordion.

## Swap Position with an NPC

PC can Swap position with an NPC if: (1) PC has Parrot; (2) PC stands on land; (3) PC and the NPC are in a straight line; (4) There is nothing but continuous swamp in-between them. Swapping costs no Mana Point. It is available even if your MP is below 1.

## Land

You can leave swamp and go back to land if: (1) You are in swamp; (2) You are adjacent to a land grid that is not occupied by an NPC. Landing costs 1 Mana Point if your current MP is greater than 2, otherwise it costs 0 MP.

## Light or Teleport to a Harbor

You can Light a harbor if: (1) You are obsessed by a Ghost; (2) You are adjacent to or inside a harbor. Lighting costs no Mana Point. After that, you restore 1 MP, and are no longer obsessed. If you have Parrot, you can Light a harbor from a distance, which follows the same restrictions as Swapping. You can Teleport to a harbor if you have both Parrot and Accordion. Lighting has a higher priority over Teleporting.
