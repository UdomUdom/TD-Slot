extends Node
# res://core/game_manager.gd

# สมมติว่านี่คือ Node "Entities/Units" ในฉาก Battlefield ที่เราจะเอาทหารไปแปะไว้
var unit_container: Node2D 

# ตัวแปรเก็บโฟลเดอร์กระสุน (ตั้งค่าจาก battlefield.gd)
var projectile_container: Node2D 

func _ready() -> void:
	SignalBus.unit_spawn_requested.connect(_on_unit_spawn_requested)
	# แอบฟังเสียงปืน
	SignalBus.projectile_fired.connect(_on_projectile_fired)

func _on_projectile_fired(proj_data: Resource, spawn_pos: Vector2, lane_id: int, direction: int, target_group: String) -> void:
	if not is_instance_valid(projectile_container): return
	
	# ดึงกระสุนจาก Pool
	var proj_instance = PoolManager.get_instance(proj_data.projectile_scene, proj_data.id)
	projectile_container.add_child(proj_instance)
	
	# สั่งกระสุนพุ่ง!
	proj_instance.setup(proj_data, spawn_pos, direction, target_group)

# UI กดปุ่ม -> ส่ง UnitData กับ Lane ที่จะลงมาที่นี่
func _on_unit_spawn_requested(unit_data: Resource, lane_id: int) -> void:
	if not is_instance_valid(unit_container):
		push_warning("GameManager: Unit container not set!")
		return

	# เช็คว่าเงินพอไหม? ถ้าพอ ระบบจะหักเงินทันที
	if EconomyManager.spend_money(unit_data.cost):
		_spawn_unit(unit_data, lane_id)
	else:
		print("Not enough money!") # เอาไว้เทส เดี๋ยวค่อยทำ UI เด้งเตือน

func _spawn_unit(unit_data: Resource, lane_id: int) -> void:
	# ดึงข้อมูลเลนจาก LaneManager เพื่อหาแกน Y
	var lane_y_pos = 0.0
	if LaneManager.active_lanes.has(lane_id):
		lane_y_pos = LaneManager.active_lanes[lane_id]["data"].y_position
	
	# กำหนดจุดเกิด (ผู้เล่นมักจะเกิดฝั่งซ้ายสุด สมมติแกน X = 100)
	var spawn_pos = Vector2(100, lane_y_pos)
	
	# ดึงยูนิตจาก Pool
	var unit_instance = PoolManager.get_instance(unit_data.unit_scene, unit_data.id)
	unit_container.add_child(unit_instance)
	
	# ปลุกชีพและโยน Data ให้มัน
	unit_instance.setup(unit_data, lane_id, spawn_pos)
	
	# ประกาศให้โลกรู้ว่าเกิดแล้ว
	SignalBus.unit_spawned.emit(unit_instance, lane_id)
