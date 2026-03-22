extends Area2D
class_name UnitController
# res://entities/actors/unit_controller.gd

# --- Component References ---
# ลาก Node ย่อยต่างๆ มาใส่ในช่องเหล่านี้ผ่าน Inspector ฝั่งขวามือ
@export var visuals: Node2D # Sprite2D หรือ AnimatedSprite2D
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
# @export var targeting_component: TargetingComponent # เตรียมไว้สำหรับตอนทำ Auto-combat
# @export var weapon_component: WeaponComponent       # เตรียมไว้สำหรับตอนทำ Auto-combat

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
		# ถ้าใน UnitData ยังไม่มี move_speed อย่าลืมไปเพิ่ม property ด้วยนะครับ
		movement_component.speed = unit_data.get("move_speed", 50.0)
		movement_component.direction = 1
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
