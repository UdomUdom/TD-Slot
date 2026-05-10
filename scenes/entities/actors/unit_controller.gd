extends Area2D
class_name UnitController
# --- Component References ---
# ลาก Node ย่อยต่างๆ มาใส่ในช่องเหล่านี้ผ่าน Inspector ฝั่งขวามือ
@export var visuals: Node2D # Sprite2D หรือ AnimatedSprite2D
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var targeting_component: TargetingComponent
@export var weapon_component: WeaponComponent

# --- State & Data ---
var unit_data: Resource # ใส่ type แบบหลวมๆ ไว้ก่อน หรือใช้ UnitData ถ้าระบบรองรับ
var current_lane_id: int
var hitbox_radius: float = 5.0

func _ready() -> void:
	# เชื่อมต่อ Signal จาก Component เข้ามาที่ Controller
	if health_component:
		health_component.died.connect(_on_health_depleted)

# --- Initialization ---
# ฟังก์ชันนี้จะถูกเรียกโดยระบบ Spawn หลังจากดึง Object ออกมาจาก PoolManager
func setup(data: Resource, lane_id: int, spawn_pos: Vector2) -> void:
	unit_data = data
	current_lane_id = lane_id
	global_position = spawn_pos
	add_to_group("units")
	
	# แจกจ่ายข้อมูลให้ Components
	_initialize_components()
	
	# ลงทะเบียนตัวเองเข้าสู่ระบบ Lane
	# สมมติว่านี่คือฝั่งผู้เล่น เราจะใส่ Group เป็น "units" (ถ้าเป็นศัตรูจะเป็น "enemies")
	LaneManager.register_entity(self, current_lane_id, "units")

func _initialize_components() -> void:
	if visuals is AnimatedSprite2D and unit_data.get("animation_set") != null:
		visuals.sprite_frames = unit_data.animation_set
		
	if health_component:
		# --- เปลี่ยนวิธีดึงค่าให้ผ่าน Manager ---
		var final_hp = int(UpgradeManager.get_final_stat("max_health", float(unit_data.max_health)))
		health_component.initialize(final_hp)
		
	if movement_component:
		var final_speed = UpgradeManager.get_final_stat("move_speed", unit_data.move_speed)
		movement_component.speed = final_speed
		movement_component.direction = 1
		movement_component.current_lane_id = current_lane_id
		movement_component.resume_movement()
		
	if targeting_component:
		var final_range = UpgradeManager.get_final_stat("attack_range", unit_data.attack_range)
		targeting_component.setup(current_lane_id, final_range, "enemies")
		
	if weapon_component:
		var final_dmg = int(UpgradeManager.get_final_stat("base_damage", float(unit_data.base_damage)))
		var final_atk_cd = UpgradeManager.get_final_stat("attack_cooldown", unit_data.attack_cooldown)
		
		weapon_component.is_ranged = unit_data.get("is_ranged")
		weapon_component.projectile_data = unit_data.get("projectile_data")
		
		weapon_component.setup(
			final_dmg,
			final_atk_cd,
			current_lane_id, 
			1,             
			"enemies"  
			)
			
func _process(delta: float) -> void:
	if health_component and health_component.current_health <= 0:
		return
		
	if targeting_component and weapon_component:
		var target = targeting_component.get_target()
		
		if target:
			movement_component.stop_movement()
			# Play attack animation!
			if visuals is AnimatedSprite2D:
				visuals.play("attack")
				
			if weapon_component.can_attack():
				weapon_component.attack(target)
		else:
			movement_component.resume_movement()
			# Play walk animation!
			if visuals is AnimatedSprite2D:
				visuals.play("walk")
			
# --- Event Handlers ---
func _on_health_depleted() -> void:
	die()

func die() -> void:
	# Optional: Play death animation before freeing
	#if visuals is AnimatedSprite2D: visuals.play("die")
	LaneManager.unregister_entity(self, current_lane_id, "units")
	
	# คืนร่างกลับ Pool (ลบบรรทัดที่ซ้ำซ้อนด้านล่างออก ให้เหลือแค่อันเดียวแบบนี้ครับ)
	PoolManager.return_instance(self, unit_data.id)

# (เสริม) ฟังก์ชันรับ Damage จะถูกส่งต่อไปที่ HealthComponent
func take_damage(amount: int, attacker: Node2D = null) -> void:
	if health_component:
		health_component.take_damage(amount, attacker)

func add_shield(amount: int) -> void:
	if health_component:
		health_component.add_shield(amount)

func heal(amount: int) -> void:
	if health_component:
		health_component.heal(amount)
