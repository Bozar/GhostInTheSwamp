# Game Settings

[INPUT_HINT]

Edit `data/setting.json` for play testing. You can also change settings in debug menu by pressing V. Debug settings overwrite their counterparts in `data/setting.json`. All settings take effect when starting a new game.

When in debug menu, if a text field requires a boolean value, strings match this pattern are true: `^(true|t|yes|y|[1-9]\d*)$`.

Set `rng_seed` to a positive integer as a random number generator seed. When in debug menu, seed digits can be separated by characters: `[-,.\s]`. For example: `12-3,4.56` is the same as `123456`.

Set `wizard_mode` to `true` to enable wizard keys. There will be a plus symbol beside the version number in the lower right corner of the screen, and you will be able to use wizard keys (see Key Bindings).

Set `show_full_map` to `true` to disable fog of war.

Leave `palette` blank to use the default color theme. If you want to use another theme, copy a json file (for example, `blue.json`) from `palette/` to `data/`, and then feed `palette` with a file name with or without the json file extension (both `blue` and `blue.json` works). You can also create your own theme based on `default.json`.
