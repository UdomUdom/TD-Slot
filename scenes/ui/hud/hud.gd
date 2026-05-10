extends Control
# res://ui/hud/hud.gd

@onready var money_label: Label = $MoneyLabel

var chaos_label: Label
var synergy_label: Label
var lane_modifier_label: Label
var left_vbox: VBoxContainer
var right_vbox: VBoxContainer

func _ready() -> void:
	SignalBus.money_changed.connect(_on_money_changed)
	SignalBus.chaos_meter_changed.connect(_on_chaos_changed)
	SignalBus.frenzy_mode_started.connect(_on_frenzy_started)
	SignalBus.frenzy_mode_ended.connect(_on_frenzy_ended)
	SynergyManager.synergies_updated.connect(_update_synergy_display)
	
	_create_dynamic_ui()
	_update_lane_modifiers_display()

func _create_dynamic_ui() -> void:
	# Container for Left side info (Chaos, Synergies)
	left_vbox = VBoxContainer.new()
	left_vbox.position = Vector2(20, 20)
	add_child(left_vbox)
	
	chaos_label = Label.new()
	chaos_label.text = "Chaos: 0%"
	left_vbox.add_child(chaos_label)
	
	synergy_label = Label.new()
	synergy_label.text = "Synergies: None"
	left_vbox.add_child(synergy_label)
	
	# Container for Right side info (Lane Modifiers)
	right_vbox = VBoxContainer.new()
	right_vbox.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right_vbox.offset_left = -250
	right_vbox.offset_top = 20
	add_child(right_vbox)
	
	lane_modifier_label = Label.new()
	lane_modifier_label.text = "Lanes: Normal"
	right_vbox.add_child(lane_modifier_label)
	
	# Move money label to top center
	money_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	money_label.offset_top = 20
	money_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _on_money_changed(current_amount: int) -> void:
	money_label.text = "CREDITS: " + str(current_amount)

func _on_chaos_changed(current: float, max_val: float) -> void:
	chaos_label.text = "CHAOS ENGINE: %d%%" % int((current / max_val) * 100)

func _on_frenzy_started() -> void:
	chaos_label.text = ">>> FRENZY ACTIVE <<<"
	chaos_label.modulate = Color.GOLD

func _on_frenzy_ended() -> void:
	chaos_label.text = "CHAOS ENGINE: 0%"
	chaos_label.modulate = Color.WHITE

func _update_lane_modifiers_display() -> void:
	var text = "Lanes:\n"
	for lane_id in LaneManager.lane_modifiers.keys():
		var mods = LaneManager.lane_modifiers[lane_id]
		var lane_name = "Lane %d" % lane_id
		text += "%s: Spd x%.1f, Rng x%.1f\n" % [lane_name, mods["speed"], mods["range"]]
	lane_modifier_label.text = text

func _update_synergy_display() -> void:
	var text = "Synergies:\n"
	var counts = SynergyManager.active_counts
	
	if counts[UnitData.UnitClass.SOLDIER] >= 3:
		var bonus = SynergyManager.get_synergy_bonus(UnitData.UnitClass.SOLDIER)
		text += "Soldier (%d): +%d%% Atk Spd\n" % [counts[UnitData.UnitClass.SOLDIER], int(bonus * 100)]
	
	if counts[UnitData.UnitClass.TECH] >= 2:
		var bonus = SynergyManager.get_synergy_bonus(UnitData.UnitClass.TECH)
		text += "Tech (%d): -%d%% Slot Cost\n" % [counts[UnitData.UnitClass.TECH], int(bonus * 100)]
		
	if counts[UnitData.UnitClass.GUARDIAN] >= 2:
		text += "Guardian (%d): Front Shields\n" % counts[UnitData.UnitClass.GUARDIAN]
		
	if counts[UnitData.UnitClass.MUTANT] >= 2:
		var bonus = SynergyManager.get_synergy_bonus(UnitData.UnitClass.MUTANT)
		text += "Mutant (%d): %d%% Life Steal\n" % [counts[UnitData.UnitClass.MUTANT], int(bonus * 100)]
		
	if text == "Synergies:\n":
		text = "Synergies: None"
		
	synergy_label.text = text
