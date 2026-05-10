# Technical Improvement Log

## Core Systems
- Created ChaosManager to handle the Chaos Meter and Frenzy Mode state.
- Created SynergyManager to track unit classes and provide dynamic bonuses to combat and economy.
- Integrated ChaosManager and SynergyManager into project autoloads.
- Updated SignalBus with signals for projectile interactions (blocked, dodged) and chaos state changes.
- Modified EconomyManager to implement double gold rewards during Frenzy Mode.

## Combat Mechanics
- Added unit_class property to UnitData and updated unit resources (Soldier, Gunner) with appropriate classes.
- Updated WeaponComponent to apply attack speed bonuses derived from active Soldier Synergies.
- Modified SlotMachineManager to apply cost reductions based on active Tech Synergies.
- Implemented automatic free spins in SlotMachineManager when Frenzy Mode is active.

## Projectile System
- Added is_splinter and splinter_count properties to ProjectileData.
- Updated BaseProjectile logic to handle splintering on impact, spawning secondary projectiles via the SignalBus.
- Implemented projectile-based chaos generation, where blocking or dodging projectiles contributes to the Chaos Meter.

## User Interface
- Updated HUD controller to dynamically instantiate and manage a Chaos Meter display.
- Implemented a real-time Synergy Tracker in the HUD to show active unit class counts and levels.
- Added visual feedback in the HUD for Frenzy Mode activation and depletion.
- Updated SlotMachine UI logic to reflect dynamic cost changes from Tech Synergies.
- Added Lane Modifiers display to the HUD showing real-time speed and range scales.

## Synergies and Lane Modifiers
- Implemented Guardian Synergy: Provides automatic energy shields to front-most units in each lane every 5 seconds.
- Implemented Mutant Synergy: Grants Mutant units a chance to heal 10% HP upon killing an enemy.
- Developed Environmental Lane Modifiers system affecting unit movement speed and attack range.
- Integrated Kinetic Absorption: Shield damage is now converted into chaos energy, feeding the Frenzy system.
- Enhanced entity tracking to provide kill credit for both melee and projectile attacks, enabling kill-based synergy effects.
- Fixed signal and method signature mismatches after upgrading combat tracking (BaseStructure and WaveManager updates).

## Level and Content Upgrades
- Implemented LevelData resource system to unify stage configurations (lanes, waves, rewards, upgrades).
- Created Guardian Mech unit data with high health and Guardian class synergy.
- Created Bio-Mutant unit data with high speed/damage and Mutant class synergy.
- Integrated icon.svg as a mock visual design for new units using a specialized SpriteFrames resource.
- Refactored Battlefield logic to utilize the new LevelData system for centralized stage management.

## UI and Layout Improvements
- Redesigned HUD layout using VBox/HBox containers for better information density.
- Repositioned Credits (Money) display to top center for better visibility.
- Grouped Chaos Engine and Synergies status to the left side of the screen.
- Moved Lane Modifiers info to the right side of the screen.
- Upgraded Slot Machine UI with a 3-reel visual layout and spinning animation logic.
- Integrated Tech Synergy cost reduction directly into the Slot Machine spin button text.

## Session and Roster Management
- Implemented dynamic HUD button generation that automatically synchronizes with the player's selected unit roster from the `GameSession`.
- Updated `SignalBus` to use `Resource`-based signatures for `unit_spawn_requested`, ensuring type safety across the spawning pipeline.
- Added automatic debug unit initialization in `Battlefield` to allow for immediate testing of gameplay without going through selection menus.

## Gameplay and UX Improvements
- Added 'R' hotkey to instantly reload the current scene, facilitating faster iteration during development.
- Implemented 'Escape' shortcut to return to the Main Menu from the battlefield.
- Fixed signal and method signature mismatches in the unit spawning system to ensure stable gameplay transitions.

## Screen Resolution and Visual Polish
- Enabled "Expand" stretch aspect in project settings to support various screen resolutions while maintaining design integrity.
- Optimized hitboxes for Units and Projectiles, reducing collision shapes for a more precise and rewarding "bullet hell" experience.
- Improved UI anchoring and scaling across selection screens and HUD.

## Game Loop and Progression
- Implemented a new **Stage Selection System**, allowing players to choose their level before selecting their unit roster.
- Added `GameSession` persistence for `selected_level`, unifying the flow between menus and gameplay.
- Created new `Stage 2` and `Stage 3` configurations with increased lane counts (up to 5 lanes) and scaled difficulty multipliers.
- Refined the HUD to dynamically distribute unit spawn buttons across available lanes based on the current level's lane configuration.
- Added lane-specific spawning logic to ensure units are better distributed at the start of a mission.
