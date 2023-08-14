# feather-trapper

> This script manages all aspects of hunting with Feather Core system. This includes skinning, butchering, and transporting various animal skins and bodies while on horseback.

## Features
- Spawn a legendary animal : ``CreateLegendaryAnimal`` can be called using the following parameters: ``modelHash``, ``outfit``, ``coords``, ``isnetwork``, ``haveBlip``.

    ```lua
    exports['feather-trapper'].CreateLegendaryAnimal('a_c_buck_01', 1, vector4(-350.03, 786.39, 115.94, 149.6), true, true)
     ```
    
- When you kill animals, you will be able to choose to butcher them to receive the associated items in the loots table.

- There are butchers present on the map, which enables you to sell hides and animals in exchange for money. You will be offered a sale prompt if you or your last mount is carrying an animal or hide.

- Horses can carry up to three small animal skins, one animal or a large skin on its back and, if a horse is equipped with a saddle, two animals on its side.

- The price is determined by the quality of the animal and hide. An animal that is cleanly killed sells for a higher price than one that is damaged by the player.

- The sale value of legendary hides are taken into consideration.

## Screenshots

![App Screenshot](https://i.ibb.co/30RnbMd/Capture-d-cran-2023-08-14-033703.png)

## Installation
1. Download the latest release `feather-trapper.zip` at [/releases/latest](https://github.com/FeatherFramework/feather-trapper/releases/latest)
2. Extract and place `feather-trapper` into your `resources` folder
3. Add `ensure feather-trapper` to your `server.cfg` file

4. Restart your server (unless you have nightly restarts)

## How-to-configure

- The configuration for prices and non-playable characters (NPC) butchers can be found in `shared/data/butchers.lua`.
- The configuration for the animal's loot can be found in `shared/data/loots.lua`.

## Disclaimers and Credits
Thanks to BCC and Feather Team

## Dependency
ensure `feather-core`

# Tasks to be completed
- [ ] Implement native notifications.
- [ ] Incorporate loot into the player's inventory.
- [ ] Pay the player after they sell something to a butcher.
- [ ] Spawn the butcher upon character spawn.
- [ ] Implement a system to adjust prices based on the quality of the skinned carcass.
- [ ] Incorporate a hunting cart.
