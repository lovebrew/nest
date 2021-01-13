# nëst

## Overview

nëst is a compatability layer library for [LÖVE Potion](https://github.com/TurtleP/LovePotion) to use in the [LÖVE framework](https://love2d.org). The main issue that people have when creating games in LÖVE is that they want to also make it work on LÖVE Potion. It usually works, but the main issue is either missing features (e.g. 3DS lack of SpriteBatches) or minor differences, like `gamepad` constants (however the latter is fixed in 2.0.0+).

Currently nëst supports LÖVE Potion version 2.0.0 which is currently a work-in-progress. Please note that if something goes wrong while testing on hardware, it is likely something in your own code, depending on the situation. I also cannot add functionality that does not exist to this library that is not in LÖVE Potion, but I can add it if it's feasible to the framework, and therefore, add it here.

## Usage

Simply `require` the library folder and call the load function with the appropriate flag.

```lua
local nest = require('path.to.nest')
nest.load(nest.flags.MY_FLAG_HERE)
```

Available (and supported) flags:

| Name                  | Description                         |
|-----------------------|-------------------------------------|
| USE_HAC               | Enable Nintendo Switch              |
| USE_CTR               | Enable Nintendo 3DS                 |
| USE_HAC_WITH_KEYBOARD | Enable Switch with Keyboard support |
| USE_CTR_WITH_KEYBOARD | Enable 3DS with Keyboard support    |

## Notes

nëst will not automatically handle changes between 3DS and Switch. You as the developer are responsible to make code work on whichever platforms you choose. Usually just one of the consoles and PC.
