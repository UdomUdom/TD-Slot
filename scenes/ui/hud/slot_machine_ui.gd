extends Control
# res://ui/hud/slot_machine_ui.gd

@onready var spin_button: Button = $Panel/VBoxContainer/SpinButton
@onready var result_label: Label = $Panel/VBoxContainer/ResultLabel
@onready var reel1: Label = $Panel/VBoxContainer/HBoxContainer/Reel1
@onready var reel2: Label = $Panel/VBoxContainer/HBoxContainer/Reel2
@onready var reel3: Label = $Panel/VBoxContainer/HBoxContainer/Reel3

var is_spinning: bool = false

func _ready() -> void:
	spin_button.pressed.connect(_on_spin_pressed)
	SignalBus.slot_reward_granted.connect(_on_reward_granted)
	SignalBus.money_changed.connect(_on_money_changed)

func _on_spin_pressed() -> void:
	if is_spinning: return
	SignalBus.slot_spin_requested.emit()

func _on_reward_granted(reward: SlotRewardData) -> void:
	_play_spin_animation(reward)

func _play_spin_animation(reward: SlotRewardData) -> void:
	is_spinning = true
	spin_button.disabled = true
	result_label.text = "Spinning..."
	
	var symbols = ["7", "X", "$", "!", "#", "@"]
	
	for i in range(10):
		reel1.text = symbols.pick_random()
		reel2.text = symbols.pick_random()
		reel3.text = symbols.pick_random()
		await get_tree().create_timer(0.1).timeout
	
	var char_res = reward.display_name.substr(0, 1)
	reel1.text = char_res
	reel2.text = char_res
	reel3.text = char_res
	
	result_label.text = "WIN: " + reward.display_name
	is_spinning = false
	_on_money_changed(EconomyManager.current_money)

func _on_money_changed(current_money: int) -> void:
	if not is_spinning:
		var cost_reduction = SynergyManager.get_synergy_bonus(UnitData.UnitClass.TECH)
		var final_cost = int(SlotMachineManager.spin_cost * (1.0 - cost_reduction))
		spin_button.disabled = current_money < final_cost
		spin_button.text = "SPIN SLOT ($%d)" % final_cost
