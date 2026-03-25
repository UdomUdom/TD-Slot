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
	
	# แจกจ่ายข้อมูลให้ Components
	_initialize_components()
	
	# ลงทะเบียนตัวเองเข้าสู่ระบบ Lane
	# สมมติว่านี่คือฝั่งผู้เล่น เราจะใส่ Group เป็น "units" (ถ้าเป็นศัตรูจะเป็น "enemies")
	LaneManager.register_entity(self, current_lane_id, "units")

func _initialize_components() -> void:
	if health_component:
		# ส่ง max_health จาก Resource ไปตั้งค่าเลือด 
		health_component.initialize(unit_data.max_health)
		
	if movement_component:
		# กำหนดความเร็วและทิศทาง (ยูนิตผู้เล่นเดินไปทางขวา = 1, ศัตรู = -1) 
		movement_component.speed = unit_data.move_speed 
		movement_component.direction = 1
		movement_component.resume_movement()
		
	if targeting_component:
		targeting_component.setup(current_lane_id, unit_data.attack_range, "enemies")
		
	if weapon_component:
		weapon_component.setup(unit_data.base_damage, unit_data.attack_cooldown)

func _process(delta: float) -> void:
	# ถ้าตายแล้ว ไม่ต้องทำอะไร
	if health_component and health_component.current_health <= 0:
		return
		
	if targeting_component and weapon_component:
		var target = targeting_component.get_target()
		
		if target:
			# เจอศัตรู: หยุดเดิน แล้วโจมตี
			movement_component.stop_movement()
			if weapon_component.can_attack():
				weapon_component.attack(target)
		else:
			# ไม่เจอศัตรู: เดินหน้าต่อไป
			movement_component.resume_movement()
			
# --- Event Handlers ---
func _on_health_depleted() -> void:
	die()

func die() -> void:
	# 1. แจ้งเตือนระบบว่าตายแล้ว เพื่อเคลียร์ออกจาก Lane
	LaneManager.unregister_entity(self, current_lane_id, "units")
	
	# (Option) ส่ง Signal ไปบอกระบบใหญ่ เผื่อต้องมีการทำ Death VFX หรือเสียง
	# SignalBus.unit_died.emit(unit_data.id, current_lane_id)
	
	# 2. ส่งคืนเข้า Pool แทนการใช้ queue_free()
	PoolManager.return_instance(self, unit_data.id)

# (เสริม) ฟังก์ชันรับ Damage จะถูกส่งต่อไปที่ HealthComponent
func take_damage(amount: int) -> void:
	if health_component:
		health_component.take_damage(amount)
