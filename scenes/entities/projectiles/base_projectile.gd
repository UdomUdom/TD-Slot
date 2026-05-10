extends Area2D
class_name BaseProjectile
# res://entities/projectiles/base_projectile.gd

var data: ProjectileData
var direction: int = 1
var target_group: String = ""
var pierced_count: int = 0
var attacker: Node2D = null

func _ready() -> void:
	# เมื่อมีอะไรเข้ามาชนกล่อง Area2D ให้เรียกฟังก์ชันนี้
	area_entered.connect(_on_area_entered)

func setup(proj_data: ProjectileData, spawn_pos: Vector2, dir: int, group_to_hit: String, _attacker: Node2D = null) -> void:
	data = proj_data
	global_position = spawn_pos
	direction = dir
	target_group = group_to_hit
	pierced_count = 0
	attacker = _attacker

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
			area.take_damage(data.damage, attacker)
			pierced_count += 1
			
			if data.is_splinter:
				_spawn_splinters()
			
			# ถ้ายิงทะลุครบโควต้าแล้ว ให้ทำลายกระสุนทิ้ง
			if pierced_count >= data.pierce_count:
				_destroy()

func _spawn_splinters() -> void:
	# Duplicate bullet but modify its logic, we can fake it by emitting projectile fired but on different lanes
	# However, since lanes are discrete, splintering could mean firing into adjacent lanes
	# Or we can just spawn child projectiles directly visually, but let's use the signal bus
	for i in range(data.splinter_count):
		var y_offset = (i * 20.0) - (data.splinter_count * 10.0)
		var spawn_pos = global_position + Vector2(0, y_offset)
		# We emit a projectile_fired signal using a basic bullet data so they don't infinitely splinter
		# But since we only have `data` here, let's instantiate without `is_splinter`
		var new_data = data.duplicate()
		new_data.is_splinter = false
		new_data.damage = max(1, int(data.damage / 2)) # Half damage
		
		# Let GameManager handle spawning by emitting the signal
		# We might not know lane id, but we can pass 0 or a proxy
		SignalBus.projectile_fired.emit(new_data, spawn_pos, 0, direction, target_group, attacker)

func _destroy() -> void:
	# คืนกระสุนเข้าคลัง PoolManager เพื่อรอนำกลับมาใช้ใหม่
	PoolManager.return_instance(self, data.id)
