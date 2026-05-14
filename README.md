# TD-Slot

TD-Slot is a high-octane, lane-based tower defense game built with **Godot 4.x**.

## Core Features

### Strategic Gameplay
*   **Unit Roster Selection:** Choose up to 6 unique units before each mission to build your perfect squad.
*   **3-Lane or More Combat:** Defend your base across multiple lanes, managing positioning and resource allocation.
*   **Synergy System:** Mix and match unit classes (**Soldier, Tech, Guardian, Mutant**) to unlock powerful passive bonuses:
    *   **Soldiers:** Increased Attack Speed.
    *   **Tech:** Reduced Slot Machine costs.
    *   **Guardians:** Defensive front-line shields.
    *   **Mutants:** Life-steal capabilities.

### Progression & Upgrades
*   **In-Game Economy:** Manage Credits earned through passive income and enemy kills.
*   **Dynamic Upgrades:** Select permanent stat boosts (Attack, Health, Cooldown) between waves to adapt to increasing difficulty.
*   **Wave System:** Face increasingly difficult waves of enemies culminating in epic boss encounters.

### Technical Excellence
*   **Data-Driven Design:** Units, Levels, Waves, and Projectiles are all defined as Godot Resources (`.tres`), making the game extremely easy to mod or extend.
*   **Signal-Bus Architecture:** Decoupled systems using a central `SignalBus` for clean, maintainable, and scalable code.
*   **Object Pooling:** Highly optimized performance using a dedicated `PoolManager` for entities and projectiles.

## Tech Stack
*   **Engine:** Godot 4.3+
*   **Language:** GDScript
*   **Renderer:** Mobile / Compatibility
*   **Architecture:** Component-based actors (Health, Movement, Combat components).

## Project Structure
*   `core/`: The "brains" of the game (Managers for Economy, Chaos, Lanes, etc.).
*   `data/`: Resource files defining all game entities and levels.
*   `scenes/`:
    *   `entities/`: Actors (Units/Enemies) and their components.
    *   `levels/`: The main battlefield and level logic.
    *   `ui/`: HUD, Slot Machine interface, and Menus.
*   `assets/`: Visual and audio assets.

## Getting Started
1.  Clone the repository.
2.  Open `project.godot` in Godot Engine 4.3 or newer.
3.  Press **F5** to start from the Main Menu.

## Info
This project is incomplete. Feel free to use, modify, and distribute it for your own projects!

## preview

![image](/showcase/menu.png)
![image](/showcase/stage_select.png)
![image](/showcase/unit_select.png)
![image](/showcase/lane_game.png)
