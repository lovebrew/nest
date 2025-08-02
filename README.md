# nëst

## Overview

nëst is a compatibility layer library for [LÖVE Potion](https://github.com/TurtleP/LovePotion) to use in the [LÖVE framework](https://love2d.org). The main issue that people have when creating games in LÖVE is that they want to also make it work on LÖVE Potion. It usually works, but the main issue is either missing features (e.g. 3DS lack of SpriteBatches) or minor differences.

Currently nëst supports LÖVE Potion version 2.0.0 and up. Please note that if something goes wrong while testing on hardware, it is likely something in your own code, depending on the situation. I also cannot add functionality that does not exist to this library that is not in LÖVE Potion, but I can add it if it's feasible to the framework, and therefore, add it here.

## Usage

Simply `require` the library folder and call the init function with the appropriate options-filled table at the top of your `main.lua`, outside of LÖVE functions.

```lua
require('path.to.nest').init(config)

function love.load()
  -- code
end

-- mode code
```

When running on-console, the `init` function will no-op, preventing nëst from operating.

### Configuration Options

| Name            | Description                                         | Values                   | Required | Default |
| --------------- | --------------------------------------------------- | ------------------------ | :------: | :-----: |
| console         | Enable a specific console mode                      | "3ds", "switch", "wiiu" |    x     |   nil   |
| scale           | Scale the window size                               | 1, 2, or 3               |    ×     |    1    |
| emulateJoystick | Enable joystick emulation via keyboard input        | false, true              |    ×     |  true   |
| docked          | Set whether the Nintendo Switch emulation is docked | false, true              |    ×     |  false  |
| mode            | Set the TV mode for the Wii U                       | "480p", "720p", "1080p"  |    ×     | "720p"  |

The configuration is a table with these options. For example:

```lua
require("nest").init({console = "3ds"})
```

This would enable 3DS mode.

## Notes

1. nëst will not automatically handle changes between the consoles. You as the developer are responsible to make code work on whichever platforms you choose. Usually just one of the consoles and PC.
2. In Wii U emulation, if you wish to access the gamepad view, press tab. This will swap between the TV and Gamepad!
3. In Switch emulation, you can press tab to swap between docked and undocked mode.
4. In 3DS emulation, you can use the scroll wheel to change the 3d depth slider value (0.1 increments)
