# nëst

## Overview

nëst is a compatability layer library for [Löve Potion](https://github.com/TurtleP/LovePotion) to use in the [LÖVE framework](https://love2d.org). The main issue that people have when creating games in LÖVE is that they want to also make it work on Löve Potion. It usually works, but the main issue is either missing features (e.g. 3DS lack of SpriteBatches) or minor differences, like `gamepad` constants (however the latter is fixed in 2.0.0+).

Currently nëst supports Löve Potion version 2.0.0 which is currently a work-in-progress. Please note that if something goes wrong while testing on hardware, it is likely something in your own code, depending on the situation. I also cannot add functionality that does not exist to this library that is not in Löve Potion, but I can add it if it's feasible to the framework, and therefore, add it here.

## Usage

Simply `require` the library folder and call the initialize function; pass either `ctr` for 3DS or `nx` for Switch. This will ensure the internals get set up properly.

```lua
require('path.to.nest').init('which')
```

## Notes

nëst will not automatically handle changes between 3DS and Switch. You as the developer are responsible to make code work on whichever platforms you choose. Usually just one of the consoles and PC.
