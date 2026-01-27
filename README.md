# Unicorn Flight with LÖVE

Unicorn Flight is a charming, educational LÖVE game that teaches basic arithmetic while delivering light, arcade-style action. Guide your unicorn skyward, collect coins, avoid trolls, and solve short math challenges to progress — perfect for ages 7–9.

## Gameplay

- Fly the unicorn upward using the UP arrow key.
- Reach the sun to advance stages and earn coins.
- Avoid falling trolls that can cost lives.
- Start with 3 lives and 100 coins.
- Game ends when all lives are lost by hitting trolls or the ground.

New: static collectible coins appear on the field; you must gather a small number of these between sun visits to unlock the next stage. Every stage triggers a short math challenge (20s time limit) — answer to earn bonus coins and extra lives. Problems are varied (10,000 pre-generated additions plus occasional "missing value" equations like `3 + X = 10`) and scale gently with stage.

## Prerequisites

- [LÖVE framework](https://love2d.org/) installed
- Lua and LuaRocks for unit testing:
  - Download and install LuaRocks from [luarocks.org](https://luarocks.org/)
  - Run `luarocks install busted` to install the Busted testing framework

This project is built for LÖVE 11.x and requires no external media assets; everything is drawn procedurally.

## Running the Game

Open a terminal in the project directory and run:

```
love .
```

On Windows, use the included `run_game.bat` to launch the game.

## Running Tests

After installing Busted, run:

```
busted spec/
```

## Project Structure

- `main.lua`: Main game entry point and LÖVE callbacks
- `game.lua`: Game logic, including unicorn, trolls, and game state
  - Now includes progression gating, static collectible coins, and the math-quiz system (20s per quiz)
- `unicorn.lua`: Unicorn class for movement and drawing
- `troll.lua`: Troll class for falling enemies
- `conf.lua`: LÖVE configuration
- `spec/`: Unit tests directory

## Controls

- UP arrow: Fly upward
- F11: Toggle fullscreen
- ESC: Exit game (with confirmation)
- R: Restart after game over

Educational features:
- Problems: 10,000 varied addition problems, age-targeted (7–9)
- Time-limited quizzes: 20s per problem
- Missing-operand equations appear as harder questions (e.g., `A + X = C`)

## Assets

- Unicorn and troll graphics are procedurally generated
- Rainbow background is drawn dynamically
