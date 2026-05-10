extends Node
# res://core/slot_machine_manager.gd

@export var spin_cost: int = 50
@export var frenzy_spin_interval: float = 2.0

var available_rewards: Array[SlotRewardData] = []
var frenzy_spin_timer: float = 0.0

func _ready() -> void:
	SignalBus.slot_spin_requested.connect(_on_spin_requested)
	SignalBus.frenzy_mode_started.connect(_on_frenzy_started)

func _process(delta: float) -> void:
	if ChaosManager.is_frenzy_active:
		frenzy_spin_timer -= delta
		if frenzy_spin_timer <= 0:
			frenzy_spin_timer = frenzy_spin_interval
			_spin_free()

# ฟังก์ชันสำหรับให้ด่านส่งรายชื่อรางวัลมาให้
func setup_rewards(rewards: Array[SlotRewardData]) -> void:
	available_rewards = rewards

func _on_frenzy_started() -> void:
	frenzy_spin_timer = 0.5 # หมุนทันทีหลังจากเริ่ม Frenzy แป๊บเดียว

func _on_spin_requested() -> void:
	if available_rewards.is_empty():
		push_warning("SlotMachine: ไม่มีของรางวัลในระบบ!")
		return
		
	# Apply Tech Synergy (cost reduction)
	var cost_reduction = SynergyManager.get_synergy_bonus(UnitData.UnitClass.TECH)
	var final_cost = int(spin_cost * (1.0 - cost_reduction))
	
	# เช็คเงินและหักเงินผ่าน EconomyManager
	if EconomyManager.spend_money(final_cost):
		var reward = _get_random_reward()
		_apply_reward(reward)
		
		# ส่งสัญญาณบอก UI ให้แสดงผล
		SignalBus.slot_reward_granted.emit(reward)
	else:
		print("SlotMachine: เงินไม่พอหมุนสล็อต!")

func _spin_free() -> void:
	if available_rewards.is_empty(): return
	
	var reward = _get_random_reward()
	_apply_reward(reward)
	SignalBus.slot_reward_granted.emit(reward)
	print("FRENZY FREE SPIN!")

func _get_random_reward() -> SlotRewardData:
	var total_weight: float = 0.0
	for reward in available_rewards:
		total_weight += reward.weight
		
	var random_val = randf_range(0.0, total_weight)
	var current_weight: float = 0.0
	
	for reward in available_rewards:
		current_weight += reward.weight
		if random_val <= current_weight:
			return reward
			
	return available_rewards.back() # เผื่อฉุกเฉิน

func _apply_reward(reward: SlotRewardData) -> void:
	print("SLOT MACHINE RESULT: ", reward.display_name)
	
	if reward.reward_type == SlotRewardData.RewardType.MONEY:
		EconomyManager.add_money(reward.money_amount)
		
	elif reward.reward_type == SlotRewardData.RewardType.FREE_UNIT:
		if reward.unit_to_spawn:
			# สุ่มเลนที่จะให้ทหารฟรีลงไปเกิด
			var random_lane = LaneManager.active_lanes.keys().pick_random()
			# ขอให้ GameManager เสกทหารให้ (เราจะต้องแอบไปเปิดฟังก์ชันนี้ใน GameManager เป็น public)
			GameManager.spawn_unit(reward.unit_to_spawn, random_lane)
