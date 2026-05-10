# Project Overview — Lane Defense: Bullet Hell Survivor

## Core Concept

A 2D side-scrolling lane-based strategy game that combines:

- Tower Defense
- Auto Battler
- Bullet Hell
- Survivor/Roguelike mechanics
- Slot Machine economy systems

Players defend their base by deploying human units into multiple lanes while surviving massive enemy waves and progressing through randomized upgrades.

The game focuses on:
- Strategic lane management
- Large-scale combat
- Projectile-heavy battles
- Build variety
- Procedural replayability

---

# New & Improved Features

## 1. The "Chaos Engine" (Luck & Combo Meter)
*   **Chaos Meter:** Fills as enemies are defeated and projectiles are blocked/dodged.
*   **Frenzy Mode:** When the Chaos Meter is full, the game enters "Frenzy Mode":
  *   Slot machine spins automatically for free.
  *   Unit attack speed increased by 50%.
  *   Enemies drop double gold.
*   **Luck Stat:** Influences the quality of slot rewards and the rate at which the Chaos Meter fills.

## 2. Synergy System (Unit Classes)
Units now belong to specific classes (Soldier, Tech, Guardian, Mutant). Having multiple units of the same class on the field unlocks passive bonuses:
*   **Soldier Synergy (3/6):** Increases reload speed for all units.
*   **Tech Synergy (2/4):** Slot machine spins cost 10% less per Tech unit.
*   **Guardian Synergy (2/5):** Adds a small energy shield to the front-most unit in each lane.

## 3. Bullet Interaction Upgrades
Moving beyond just "more bullets" to "smarter bullets":
*   **Kinetic Absorption:** Friendly shields convert absorbed damage into "Chaos" energy.
*   **Splinter Rounds:** Projectiles split into smaller ones on hit (Roguelike staple).
*   **Gravitational Pull:** Rare projectiles that pull enemies and other bullets toward their center.
*   **Chrono-Stasis:** Crits have a chance to freeze projectiles in a small area for 2 seconds.

---

# Theme
... (rest of the content remains the same)

## Setting

Humanity is defending the last surviving bases against hostile factions in a dark sci-fi world.

## Enemy Factions

### Robots
- Drone
- Tank Bot
- Laser Mech

### Plants
- Walking Tree
- Poison Flower
- Root Monster

### Mutants
- Zombie
- Parasite
- Bio-Robot

## Visual Style

- Pixel Art
- Dark Sci-Fi
- Neon effects
- Heavy projectile visuals
- Chaotic battlefield atmosphere

---

# Gameplay Structure

## Battlefield Layout

```text
[ Human Base ] ====================== [ Enemy Base ]
````

* 3–5 horizontal lanes
* Enemies advance toward the human base
* Player deploys units into specific lanes
* Units automatically move and attack

## Objectives

A stage can end in multiple ways:

### Victory Conditions

* Destroy enemy base
* Survive all enemy waves
* Survive until timer ends

### Defeat Conditions

* Human base destroyed

---

# Core Gameplay Loop

```text
Start Stage
↓
Generate enemy waves
↓
Player deploys units
↓
Auto battle begins
↓
Projectiles fill battlefield
↓
Collect resources
↓
Use upgrades and slot machine
↓
Survive wave / defeat boss
↓
Gain progression rewards
↓
Unlock upgrades and new content
```

---

# Features

## Lane-Based Combat

* 3–5 lanes
* Lane-specific strategy
* Some units can switch lanes
* Environmental lane modifiers:

* Day
* Night
* Water
* Air
* Blocked lanes

## Auto Combat

* Units automatically move
* Units automatically attack
* Enemy AI automatically advances

## Bullet Hell Combat

* Massive projectile counts
* Laser attacks
* Beam weapons
* Bullet spread patterns
* Boss bullet patterns

## Slot Machine Economy

Players can spin a slot machine during battle for:

* Bonus money
* Temporary buffs
* Free units
* Rare upgrades
* Emergency effects

## Roguelike Upgrade System

Randomized upgrades after waves:

* Damage
* Attack speed
* Piercing
* Explosions
* Chain lightning
* Poison
* Cooldown reduction

## Meta Progression

Permanent progression between runs:

* Unlock new units
* Unlock new weapons
* Increase base stats
* Upgrade economy
* Unlock new slot rewards

## Procedural Waves

Enemy compositions change every run.

---

# Game Mechanics

## Unit System

Units have:

* HP
* Speed
* Attack Damage
* Attack Range
* Attack Cooldown
* Cost
* Cooldown
* Lane behavior

## Unit Types

### Normal Unit
* Stays in one lane (Soldier, Gunner)

### Guardian Unit
* High HP, blocks enemies and projectiles (Guardian Mech)
* Guardian Synergy: Adds energy shields to front-most units.

### Bio-Mutant Unit
* Fast melee unit with high damage (Bio-Mutant)
* Mutant Synergy: Life steal on kill.

...

## Level System
* LevelData: A unified resource containing lanes, waves, slot rewards, and upgrades for a specific stage.
* Progression: Unlocking new stages by completing current ones.

---

# Projectile System

## Projectile Types

* Bullet
* Rocket
* Laser
* Plasma
* Beam
* Chain Lightning

## Projectile Mechanics

Projectiles support:

* Collision
* Piercing
* AoE damage
* Status effects
* Knockback
* Shields
* Reflection

---

# Economy System

## Passive Income

* Income increases over time
* Can be upgraded during battle

## Slot Machine System

### Rewards

* Gold
* Buffs
* Free units
* Global attacks
* Defensive barriers

### Risk/Reward

* Cooldown-based
* Resource-based
* Randomized outcomes

---

# Survivor Mechanics

Inspired by Vampire Survivors.

## Features

* Automatic attacks
* Large enemy density
* Scaling chaos over time
* Random upgrade choices
* Synergy-based builds
* Endless projectile patterns

## Upgrade Examples

* Explosive bullets
* Pierce shots
* Chain lightning
* Poison aura
* Bullet reflection
* Increased projectile count

---

# Progression System

## Mid-Run Progression

During battle:

* Gain upgrades
* Improve economy
* Create build synergies

## Permanent Progression

After each run:

* Unlock classes
* Unlock maps
* Unlock enemies
* Upgrade permanent stats
* Expand slot machine rewards

---

# Systems Requirements

## Required Systems

### Core Systems

* GameManager
* LaneManager
* WaveManager
* EconomyManager
* UpgradeManager
* SlotMachineManager

### Combat Systems

* ProjectileManager
* Collision System
* Targeting System
* AI Movement System

### Utility Systems

* Signal/Event Bus
* Save System
* Data Loader
* Audio Manager

---

# Architecture

## Design Pattern

The project uses:

* Resource Pattern
* Component Pattern
* Event Bus Pattern
* Object Pooling
* Data-Driven Design

## Data-Driven Resources

All gameplay content should use Godot Resources (.tres):

* UnitData
* EnemyData
* ProjectileData
* WaveData
* UpgradeData
* LaneData

---

# Performance Requirements

The game must support:

* 1000+ enemies
* 500+ projectiles
* Massive bullet hell scenes
* Large upgrade combinations

## Optimization Techniques

### Object Pooling

Avoid runtime instancing for:

* Bullets
* Enemies
* Effects
* Damage numbers

### Lightweight Collision

Prefer:

* Distance checks
* Area2D
* Batched collision checks

### Centralized Managers

Managers handle:

* Updates
* Spawning
* Projectile logic
* Wave generation

Avoid expensive per-object logic.

---

# Technical Structure

## Core Managers

* GameManager
* PoolManager
* LaneManager
* UpgradeManager
* WaveManager

## Component System

Actors are built using reusable components:

* HealthComponent
* MovementComponent
* WeaponComponent
* TargetingComponent
* LaneComponent

## Event Bus

Global signals:

* money_changed
* unit_spawn_requested
* enemy_died
* wave_started
* upgrade_selected
* base_damaged

---

* 3 lanes
* 3 units
* 3 enemies
* 1 boss
* Basic projectile system
* Basic slot machine
* Simple upgrades
* Bullet hell bosses
* Air lanes
* Shield units
* Beam weapons
* More upgrade synergies

* Meta progression
* Procedural waves
* More factions
* Advanced slot systems
* Endless mode

---

# Gameplay Identity

The game combines:

| Genre            | Inspiration       |
| ---------------- | ----------------- |
| Lane Defense     | Battle Cats       |
| Bullet Hell      | Touhou            |
| Survivor         | Vampire Survivors |
| Auto Battler     | Auto Chess        |
| Roguelike        | Hades             |
| Economy Gambling | Slot Machines     |

The result is a hybrid genre:

## "Lane Defense Bullet Hell Survivor Roguelike"

---

```
```
