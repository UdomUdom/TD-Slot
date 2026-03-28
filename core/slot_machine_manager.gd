extends Node
# res://core/slot_machine_manager.gd

@export var spin_cost: int = 50
var available_rewards: Array[SlotRewardData] = []

func _ready() -> void:
	SignalBus.slot_spin_requested.connect(_on_spin_requested)

# ฟังก์ชันสำหรับให้ด่านส่งรายชื่อรางวัลมาให้
func setup_rewards(rewards: Array[SlotRewardData]) -> void:
	available_rewards = rewards

func _on_spin_requested() -> void:
	if available_rewards.is_empty():
		push_warning("SlotMachine: ไม่มีของรางวัลในระบบ!")
		return
		
	# เช็คเงินและหักเงินผ่าน EconomyManager
	if EconomyManager.spend_money(spin_cost):
		var reward = _get_random_reward()
		_apply_reward(reward)
		
		# ส่งสัญญาณบอก UI ให้แสดงผล
		SignalBus.slot_reward_granted.emit(reward)
	else:
		print("SlotMachine: เงินไม่พอหมุนสล็อต!")

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
	print("🎰 SLOT MACHINE RESULT: ", reward.display_name)
	
	if reward.reward_type == SlotRewardData.RewardType.MONEY:
		EconomyManager.add_money(reward.money_amount)
		
	elif reward.reward_type == SlotRewardData.RewardType.FREE_UNIT:
		if reward.unit_to_spawn:
			# สุ่มเลนที่จะให้ทหารฟรีลงไปเกิด
			var random_lane = LaneManager.active_lanes.keys().pick_random()
			# ขอให้ GameManager เสกทหารให้ (เราจะต้องแอบไปเปิดฟังก์ชันนี้ใน GameManager เป็น public)
			GameManager.spawn_unit(reward.unit_to_spawn, random_lane)
