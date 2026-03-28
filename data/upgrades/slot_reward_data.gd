extends Resource
class_name SlotRewardData
# res://data/upgrades/slot_reward_data.gd

enum RewardType { MONEY, FREE_UNIT, BUFF }

@export var id: String = "reward_money_small"
@export var display_name: String = "Small Jackpot!"
@export var reward_type: RewardType = RewardType.MONEY

# โอกาสในการสุ่มได้ (ยิ่งค่าน้อย ยิ่งออกยาก เช่น 10.0 ออกบ่อยกว่า 1.0)
@export var weight: float = 10.0 

@export_group("Reward Values")
@export var money_amount: int = 100 # ใช้ถ้าเป็นประเภท MONEY
@export var unit_to_spawn: Resource # ใช้ถ้าเป็นประเภท FREE_UNIT (ใส่ UnitData)
