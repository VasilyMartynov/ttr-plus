# ttr-plus

Warhammer Online - Return of Reckoning Add-on 

Thank The Resser Plus.

## Features

- Automatically thanks the person that revived you in /say, optionally addressing them by name (same as the original addon).
- Allows setting up multiple phrases to be picked at random (new feature!)

## Installation

- Download [ttr-plus-main.zip](https://github.com/VasilyMartynov/ttr-plus/archive/main.zip).
- Extract.
- Copy `./ThankTheResserPlus` directory to your game addons folder (`./Warhammer Online - Return of Reckoning/Interface/AddOns/`).

## Usage

Addon provides simple ingame console help and instructions.

`/ttrp off` - turns Thank The Resser off \
`/ttrp on`  - turns Thank The Resser on

`/ttrp mode`   - shows current mode (random | word) \
`/ttrp word`   - sets the mode to custom phrase, default unless provided. \
`/ttrp random` - sets the mode to random pregenerated set of messages. \
Custom phrases coming sometime, maybe. \
Really, if I've to overcome my laziness and game framework.

`/ttrp <phrase>` - sets thanks phrase upon resurrection. Use `%p` to insert the resurrector's name.

`/ttrp init` - wipe and reinitialize random dictionary. \
`/ttrp test` - prints TRRP message, depending on mode.

`/ThankTheResserPlus` can be used instead of `/trrp` if you are not bored typing SO long in console while the fight engulfed around.

## Custom Messages

Dictionary phrases are stored in the local settings file upon first launch (and after you quit the game correctly).

Edit `ThankTheResserPlus.Dictionary` variable in
`%game_root%\user\settings\Martyrs Square\%username%\%char_name%\ThankTheResserPlus\SavedVariables.lua`

Better to do it before you start the game, after the first time.

Try not to overuse some fancy graphics, it will basicly break the mod.

Whenever it breaks midgame you can use `/ttrp init` to wipe changes and overwrite with initial dictionary.


## Thanks

Many thanks to [Warhammer Return of Reckoning Team ](https://www.returnofreckoning.com/)

Tools and addon Library of [Idrinth](https://tools.idrinth.de/)

Original Author of the Mod - [Sullemunk](https://www.returnofreckoning.com/forum/memberlist.php?mode=viewprofile&u=2352&sid=758cea67751329ca1d59fe277076c17d)
