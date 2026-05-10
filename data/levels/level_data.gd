extends Resource
class_name LevelData

@export var level_name: String = "Stage 1"
@export var lanes: Array[LaneData]
@export var waves: Array[WaveData]
@export var slot_rewards: Array[SlotRewardData]
@export var upgrades: Array[UpgradeData]
@export var difficulty_multiplier: float = 1.0
