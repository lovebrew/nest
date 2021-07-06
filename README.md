# nëst

## Overview

nëst is a compatability layer library for [LÖVE Potion](https://github.com/TurtleP/LovePotion) to use in the [LÖVE framework](https://love2d.org). The main issue that people have when creating games in LÖVE is that they want to also make it work on LÖVE Potion. It usually works, but the main issue is either missing features (e.g. 3DS lack of SpriteBatches) or minor differences.

Currently nëst supports LÖVE Potion version 2.0.0 and up. Please note that if something goes wrong while testing on hardware, it is likely something in your own code, depending on the situation. I also cannot add functionality that does not exist to this library that is not in LÖVE Potion, but I can add it if it's feasible to the framework, and therefore, add it here.

## Usage

Simply `require` the library folder and call the init function with the appropriate options-filled table.

```lua
require('path.to.nest'):init(config)
```

Available (and supported) options:

| Name                  | Description                                  | Values        | Required |
|-----------------------|----------------------------------------------|---------------|:--------:|
| mode                  | Enable a specific console mode               | "ctr", "hac"  | ✓        |
| scale                 | Scale the window size                        | 1, 2          | ×        |
| emulateJoystick       | Enable joystick emulation via keyboard input | false, true   | ×        |

## Notes

nëst will not automatically handle changes between 3DS and Switch. You as the developer are responsible to make code work on whichever platforms you choose. Usually just one of the consoles and PC.
