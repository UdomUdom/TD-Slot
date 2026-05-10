extends Node
# res://core/chaos_manager.gd

@export var max_chaos: float = 100.0
@export var frenzy_duration: float = 10.0

var current_chaos: float = 0.0
var current_luck: float = 1.0
var is_frenzy_active: bool = false
var frenzy_timer: float = 0.0

func _ready() -> void:
	SignalBus.enemy_died.connect(_on_enemy_died)
	SignalBus.upgrade_selected.connect(_on_upgrade_selected)
	SignalBus.projectile_blocked.connect(_on_projectile_blocked)
	SignalBus.projectile_dodged.connect(_on_projectile_dodged)

func _process(delta: float) -> void:
	if is_frenzy_active:
		frenzy_timer -= delta
		if frenzy_timer <= 0:
			end_frenzy()

func _on_enemy_died(_enemy_id: String, _reward: int, _lane_id: int, _killer: Node2D = null) -> void:
	if is_frenzy_active: return
	
	# Increase chaos based on luck
	add_chaos(2.0 * current_luck)

func _on_projectile_blocked() -> void:
	if is_frenzy_active: return
	add_chaos(0.5 * current_luck)

func _on_projectile_dodged() -> void:
	if is_frenzy_active: return
	add_chaos(1.0 * current_luck)

func add_chaos(amount: float) -> void:
	current_chaos = min(current_chaos + amount, max_chaos)
	SignalBus.chaos_meter_changed.emit(current_chaos, max_chaos)
	
	if current_chaos >= max_chaos and not is_frenzy_active:
		start_frenzy()

func start_frenzy() -> void:
	is_frenzy_active = true
	frenzy_timer = frenzy_duration
	current_chaos = max_chaos
	SignalBus.frenzy_mode_started.emit()
	print("FRENZY MODE STARTED!")

func end_frenzy() -> void:
	is_frenzy_active = false
	current_chaos = 0.0
	SignalBus.frenzy_mode_ended.emit()
	SignalBus.chaos_meter_changed.emit(current_chaos, max_chaos)
	print("Frenzy Mode Ended.")

func _on_upgrade_selected(upgrade_data: Resource) -> void:
	if upgrade_data.get("stat_to_modify") == "luck":
		current_luck += upgrade_data.add_value
		SignalBus.luck_changed.emit(current_luck)
