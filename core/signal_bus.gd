extends Node
@warning_ignore("unused_signal")
# res://core/signal_bus.gd

# --- Game Loop ---
signal game_started
signal wave_started(wave_number: int)
signal wave_cleared(wave_number: int)
signal game_over(win: bool)

# --- Entity Management ---
signal unit_spawn_requested(unit_id: String, lane_id: int)
signal unit_spawned(unit_node: Node2D, lane_id: int)
signal enemy_spawned(enemy_node: Node2D, lane_id: int)
signal enemy_died(enemy_id: String, reward: int, lane_id: int, killer: Node2D)

# --- Combat & Lanes ---
signal projectile_fired(projectile_data: Resource, spawn_pos: Vector2, lane_id: int, direction: int, target_group: String, attacker: Node2D)
signal projectile_blocked
signal projectile_dodged
signal base_damaged(amount: int, is_player_base: bool)

# --- Economy & Slot Machine ---
signal money_changed(current_amount: int)
signal slot_spin_requested
signal slot_reward_granted(reward_data: Resource)

# --- Chaos Engine ---
signal chaos_meter_changed(current_value: float, max_value: float)
signal frenzy_mode_started
signal frenzy_mode_ended
signal luck_changed(new_luck: float)

# --- Upgrade System ---
signal upgrade_screen_requested(upgrades_to_choose: Array)
signal upgrade_selected(upgrade_data: Resource)
