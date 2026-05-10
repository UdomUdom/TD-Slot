Here is a clean, structured Game Design Document (GDD) and Project Roadmap based on your files. This format is designed to be easy to read and acts as an actionable checklist for your development process.

# Game Design & Development Plan

## 1. Core Identity

**Genre:** Lane Defense + Auto Battler + Bullet Hell Survivor + Roguelike
**Core Concept:** A 2D side-scrolling strategy game where players deploy units into specific lanes to defend their base. Units auto-battle against massive waves of enemies and bullet-hell projectile patterns. Players manage an economy to spin a Slot Machine for mid-battle tide-turners and select Roguelike upgrades between waves.

## 2. Core Gameplay Loop

1. **Pre-Battle:** Select a 6-unit loadout based on desired Synergies.
2. **Combat Phase:** Deploy units into 3-5 lanes using generated income.
3. **Action Phase:** Units auto-move and auto-attack. Players dodge/block projectiles to build the Chaos Meter.
4. **Economy Phase:** Use money to deploy more units or spin the Slot Machine for buffs/free units.
5. **Progression Phase:** Clear the wave, select a randomized Survivor-style upgrade, and repeat until the Boss is defeated.

## 3. Key Gameplay Mechanics

* **The Chaos Engine:** Blocking/dodging projectiles and killing enemies fills the Chaos Meter. When full, "Frenzy Mode" activates: auto-free slot spins, 50% faster attack speed, and double gold drops.
* **Synergy System:** Deploying units of the same class unlocks passive buffs:
* *Soldier:* Increases reload speed.
* *Tech:* Reduces Slot Machine spin costs.
* *Guardian:* Grants energy shields to front-line units.
* *Mutant:* Grants life-steal on kills.


* **Lane Modifiers:** Dynamic environments (Day, Night, Water, Air) that scale unit movement speed and attack range.
* **Advanced Projectiles:** Bullets that splinter on impact, pull enemies gravitationally, or freeze in chronostasis.

## 4. Technical Architecture

This project uses highly optimized, modular Godot patterns to handle 1000+ enemies and 500+ projectiles without lag.

* **Component Pattern:** Entities are built by combining modular nodes (`HealthComponent`, `MovementComponent`, `WeaponComponent`, `TargetingComponent`).
* **Data-Driven Design:** All stats and behaviors are stored in Godot Resources (`.tres` files like `UnitData`, `EnemyData`, `LevelData`, `UpgradeData`).
* **Object Pooling:** `PoolManager` recycles nodes (bullets, enemies, damage numbers) instead of using `queue_free()` and `instantiate()` to maintain 60 FPS.
* **Event Bus:** `SignalBus` handles global communication (e.g., `enemy_died`, `projectile_fired`, `wave_cleared`) to keep code decoupled.

---

# Actionable Development Roadmap

Below is a phased plan to help you track what is finished and what to focus on next.

### Phase 1: Core Foundation (Completed)

* [x] Basic Lane system and entity registration.
* [x] Component-based unit/enemy architecture.
* [x] State management (Health, Movement, Targeting, Combat).
* [x] Object Pooling system for performance.
* [x] Base health, damage tracking, and Win/Loss conditions.

### Phase 2: Advanced Systems (Completed)

* [x] WaveManager with kill-tracking and wave-clearing logic.
* [x] EconomyManager and SlotMachineManager (with 3-reel UI).
* [x] UpgradeManager for Survivor-style post-wave buffs.
* [x] ChaosManager (Frenzy Mode) and SynergyManager (Class bonuses).
* [x] LevelData implementation to centralize stage configurations.
* [x] HUD redesign (VBox/HBox layouts, Synergy trackers, Lane Modifiers).

### Phase 3: Pre-Battle & Metagame (Current Focus)

* [ ] **Unit Selection Screen:** Build the UI for the 6-slot roster grid.
* [ ] **Game Session Autoload:** Save the player's selected 6 units and pass them into the `Battlefield` scene.
* [ ] **Main Menu:** Create a starting screen with Start, Settings, and Quit options.
* [ ] **Level Select Screen:** Allow players to unlock and choose stages driven by different `LevelData` resources.

### Phase 4: Content Expansion (Next Steps)

* [ ] **Unit/Enemy Roster:** Create more `.tres` files for classes (e.g., Drone, Laser Mech, Poison Flower).
* [ ] **Boss Encounters:** Design complex enemy types with bullet-hell emission patterns.
* [ ] **Advanced Upgrades:** Implement Splinter Rounds, Kinetic Absorption, and Chrono-Stasis logic in the `ProjectileManager`.

### Phase 5: Game Feel & Polish (Final Steps)

* [ ] **VFX:** Add camera shake on base damage, hit flashes (white sprite overlays), and particle explosions for unit deaths.
* [ ] **Audio:** Integrate BGM and SFX for shooting, UI clicks, slot machine spinning, and Frenzy Mode activation.
* [ ] **Animations:** Fully transition all placeholder icons to `AnimatedSprite2D` with specific states (idle, walk, attack, die).

Please mark [x] after it done.