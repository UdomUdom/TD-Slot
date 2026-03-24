extends Node2D
# res://scenes/levels/battlefield.gd

@export var level_lanes: Array[LaneData] # จะเอาไฟล์ .tres ทั้ง 3 ไฟล์มาใส่ตรงนี้

@onready var units_container: Node2D = $Entities/Units
@onready var enemies_container: Node2D = $Entities/Enemies

func _ready() -> void:
	# 1. โหลดข้อมูลเลนเข้าสู่สมองส่วนกลาง (LaneManager)
	if level_lanes.size() > 0:
		LaneManager.setup_lanes(level_lanes)
	else:
		push_error("Battlefield: ยังไม่ได้ใส่ข้อมูล LaneData ใน Inspector!")
		
	# 2. บอก GameManager ว่าเวลายูนิตเกิด ให้เอาไปวางไว้ที่ Node ไหน
	GameManager.unit_container = units_container
	
	# (เตรียมไว้สำหรับตอนทำ WaveManager: บอกให้ศัตรูไปเกิดที่ enemies_container)
	# WaveManager.enemy_container = enemies_container
	
	# 3. เตรียม Pool (สมมติว่าสร้าง UnitData และ base_unit.tscn ไว้แล้ว)
	# _setup_pools()
	
	# 4. ประกาศเริ่มเกม
	SignalBus.game_started.emit()

# ฟังก์ชันนี้เตรียมไว้เผื่อคุณพร้อมทำ PoolManager เต็มรูปแบบ
# func _setup_pools() -> void:
	# PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_unit.tscn"), "soldier_unit", 20)
	# PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_enemy.tscn"), "basic_enemy", 30)
