extends Node
# res://core/upgrade_manager.gd

# เก็บค่าบัฟที่สะสมไว้ทั้งหมด
# รูปแบบ: { "base_damage": {"add": 10.0, "mult": 0.0}, "max_health": {"add": 0.0, "mult": 0.2} }
var _stat_modifiers: Dictionary = {}

func _ready() -> void:
	# เมื่อผู้เล่นจิ้มเลือกอัปเกรด ให้เอามาเก็บสะสมไว้
	SignalBus.upgrade_selected.connect(_on_upgrade_selected)

func _on_upgrade_selected(upgrade: UpgradeData) -> void:
	var stat = upgrade.stat_to_modify
	
	if not _stat_modifiers.has(stat):
		_stat_modifiers[stat] = {"add": 0.0, "mult": 0.0}
		
	_stat_modifiers[stat]["add"] += upgrade.add_value
	_stat_modifiers[stat]["mult"] += upgrade.multiply_bonus
	
	print("✅ UPGRADE APPLIED: ", upgrade.display_name)

# ฟังก์ชันนี้ UnitController จะเป็นคนเรียกใช้เพื่อขอสเตตัสที่บวกบัฟแล้ว
func get_final_stat(stat_name: String, base_value: float) -> float:
	if not _stat_modifiers.has(stat_name):
		return base_value
		
	var mods = _stat_modifiers[stat_name]
	var final_value = (base_value + mods["add"]) * (1.0 + mods["mult"])
	
	# ป้องกันค่าคูลดาวน์ติดลบ
	if stat_name == "attack_cooldown" or stat_name == "spawn_cooldown":
		return max(0.1, final_value)
		
	return final_value
