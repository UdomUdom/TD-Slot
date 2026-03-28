extends Control
# res://ui/hud/slot_machine_ui.gd

@onready var spin_button: Button = $Panel/SpinButton
@onready var result_label: Label = $Panel/ResultLabel

func _ready() -> void:
	spin_button.pressed.connect(_on_spin_pressed)
	SignalBus.slot_reward_granted.connect(_on_reward_granted)
	SignalBus.money_changed.connect(_on_money_changed)

func _on_spin_pressed() -> void:
	result_label.text = "Spinning..."
	# ปิดปุ่มชั่วคราวกันคนกดสแปม
	spin_button.disabled = true 
	
	# ส่งคำสั่งไปบอก Manager
	SignalBus.slot_spin_requested.emit()

func _on_reward_granted(reward: SlotRewardData) -> void:
	# ดีเลย์ให้ความรู้สึกเหมือนกำลังลุ้นสล็อต
	await get_tree().create_timer(1.0).timeout 
	
	result_label.text = "You won:\n" + reward.display_name
	
	# เช็คเงินอีกรอบก่อนเปิดปุ่มให้กดใหม่
	_on_money_changed(EconomyManager.current_money)

func _on_money_changed(current_money: int) -> void:
	# ถ้าเงินน้อยกว่าค่าหมุน (สมมติ 50) ปุ่มจะกดไม่ได้
	spin_button.disabled = current_money < SlotMachineManager.spin_cost
