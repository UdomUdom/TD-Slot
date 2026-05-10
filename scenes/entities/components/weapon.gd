extends Node
class_name WeaponComponent

signal attacked 

# --- เพิ่มตัวแปรสำหรับปืน ---
@export var actor: Node2D # ลากโหนดแม่ (Unit/Enemy) มาใส่จาก Inspector
@export var is_ranged: bool = false
@export var projectile_data: Resource # ใส่ไฟล์ ProjectileData (.tres) 

var damage: int = 10
var attack_cooldown: float = 1.0
var _cooldown_timer: float = 0.0

# เพิ่มการรับค่าทิศทาง และ กลุ่มเป้าหมาย
var direction: int = 1
var target_group: String = "enemies" 
var current_lane_id: int = 0

func setup(dmg: int, cooldown: float, lane_id: int, dir: int, target_grp: String) -> void:
	damage = dmg
	attack_cooldown = cooldown
	current_lane_id = lane_id
	direction = dir
	target_group = target_grp
	_cooldown_timer = 0.0

func _process(delta: float) -> void:
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

func can_attack() -> bool:
	return _cooldown_timer <= 0.0

func attack(target: Node2D) -> void:
	if not can_attack(): return
		
	# Apply Soldier Synergy (cooldown reduction)
	var speed_bonus = SynergyManager.get_synergy_bonus(UnitData.UnitClass.SOLDIER)
	var final_cooldown = attack_cooldown / (1.0 + speed_bonus)
	
	_cooldown_timer = final_cooldown
	attacked.emit()
	
	if is_ranged and projectile_data:
		# ถ้ายิงปืน: ส่งสัญญาณไปให้คนเสกกระสุน
		SignalBus.projectile_fired.emit(projectile_data, actor.global_position, current_lane_id, direction, target_group, actor)
	else:
		# ถ้าตีใกล้: ทำดาเมจใส่เป้าหมายทันที
		if target.has_method("take_damage"):
			target.take_damage(damage, actor)
