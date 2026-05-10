extends Node
# res://core/synergy_manager.gd

signal synergies_updated

var active_counts: Dictionary = {
	UnitData.UnitClass.SOLDIER: 0,
	UnitData.UnitClass.TECH: 0,
	UnitData.UnitClass.GUARDIAN: 0,
	UnitData.UnitClass.MUTANT: 0
}

var guardian_timer: float = 0.0
var guardian_refresh_interval: float = 5.0

func _ready() -> void:
	SignalBus.unit_spawned.connect(_on_unit_spawned)
	SignalBus.enemy_died.connect(_on_enemy_killed)

func _on_enemy_killed(_enemy_id: String, _reward: int, _lane_id: int, killer: Node2D) -> void:
	if not is_instance_valid(killer) or not killer.is_in_group("units"): return
	
	var unit_data = killer.get("unit_data")
	if not unit_data or unit_data.unit_class != UnitData.UnitClass.MUTANT: return
	
	var heal_chance = get_synergy_bonus(UnitData.UnitClass.MUTANT)
	if heal_chance > 0 and randf() < heal_chance:
		if killer.has_method("heal"):
			var heal_amount = int(killer.health_component.max_health * 0.1)
			killer.heal(heal_amount)
			print("Mutant Synergy: Healed unit for ", heal_amount)

func _process(delta: float) -> void:
	if active_counts[UnitData.UnitClass.GUARDIAN] >= 2:
		guardian_timer += delta
		if guardian_timer >= guardian_refresh_interval:
			guardian_timer = 0.0
			_apply_guardian_shields()

func _apply_guardian_shields() -> void:
	var shield_amount = 0
	if active_counts[UnitData.UnitClass.GUARDIAN] >= 5: shield_amount = 150
	elif active_counts[UnitData.UnitClass.GUARDIAN] >= 2: shield_amount = 50
	
	if shield_amount <= 0: return
	
	for lane_id in LaneManager.active_lanes.keys():
		var front_unit = LaneManager.get_front_most_unit(lane_id)
		if front_unit and front_unit.has_method("add_shield"):
			front_unit.add_shield(shield_amount)
			print("Guardian Synergy: Shield applied to lane ", lane_id)

func _on_unit_spawned(unit_node: Node2D, _lane_id: int) -> void:
	var unit_data = unit_node.get("unit_data")
	if unit_data and unit_data.unit_class != UnitData.UnitClass.NONE:
		active_counts[unit_data.unit_class] += 1
		_update_synergies()
		
		# Connect to unit's tree_exited to know when it dies/removed
		unit_node.tree_exited.connect(_on_unit_removed.bind(unit_data.unit_class))

func _on_unit_removed(unit_class: int) -> void:
	active_counts[unit_class] -= 1
	_update_synergies()

func _update_synergies() -> void:
	synergies_updated.emit()

func get_synergy_bonus(unit_class: int) -> float:
	# Returns a multiplier or flat value based on active counts
	match unit_class:
		UnitData.UnitClass.SOLDIER:
			if active_counts[UnitData.UnitClass.SOLDIER] >= 6: return 0.25
			if active_counts[UnitData.UnitClass.SOLDIER] >= 3: return 0.10
		UnitData.UnitClass.TECH:
			if active_counts[UnitData.UnitClass.TECH] >= 4: return 0.25
			if active_counts[UnitData.UnitClass.TECH] >= 2: return 0.10
		UnitData.UnitClass.MUTANT:
			if active_counts[UnitData.UnitClass.MUTANT] >= 4: return 0.15
			if active_counts[UnitData.UnitClass.MUTANT] >= 2: return 0.05
	return 0.0
