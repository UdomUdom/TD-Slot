extends Area2D
class_name BaseProjectile
# res://entities/projectiles/base_projectile.gd

var data: ProjectileData
var direction: int = 1
var target_group: String = ""
var pierced_count: int = 0

func _ready() -> void:
	# เมื่อมีอะไรเข้ามาชนกล่อง Area2D ให้เรียกฟังก์ชันนี้
	area_entered.connect(_on_area_entered)

func setup(proj_data: ProjectileData, spawn_pos: Vector2, dir: int, group_to_hit: String) -> void:
	data = proj_data
	global_position = spawn_pos
	direction = dir
	target_group = group_to_hit
	pierced_count = 0

func _process(delta: float) -> void:
	if data == null:
		return 
	# ------------------------------------
		
	# กระสุนพุ่งไปข้างหน้า
	global_position.x += data.speed * direction * delta
	
	# ทำลายตัวเองถ้าบินออกนอกจอ (สมมติจอขอบซ้าย 0, ขวา 1500)
	if global_position.x < -200 or global_position.x > 1800:
		_destroy()

func _on_area_entered(area: Area2D) -> void:
	# เช็คว่าสิ่งที่ชน คือกลุ่มเป้าหมายที่เราต้องการยิงหรือไม่
	if area.is_in_group(target_group):
		if area.has_method("take_damage"):
			area.take_damage(data.damage)
			pierced_count += 1
			
			# ถ้ายิงทะลุครบโควต้าแล้ว ให้ทำลายกระสุนทิ้ง
			if pierced_count >= data.pierce_count:
				_destroy()

func _destroy() -> void:
	# คืนกระสุนเข้าคลัง PoolManager เพื่อรอนำกลับมาใช้ใหม่
	PoolManager.return_instance(self, data.id)
