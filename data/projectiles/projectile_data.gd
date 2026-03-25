extends Resource
class_name ProjectileData
# res://data/projectiles/projectile_data.gd

@export var id: String = "basic_bullet"
@export var speed: float = 400.0
@export var damage: int = 10
@export var pierce_count: int = 1 # จำนวนศัตรูที่ยิงทะลุได้ (1 = โดนตัวแรกระเบิดเลย)
@export var projectile_scene: PackedScene # ลาก base_projectile.tscn มาใส่ตรงนี้
