extends Resource
class_name EnemyData

@export var id: String = "basic_enemy"
@export var max_health: int = 50
@export var move_speed: float = 30.0
@export var attack_range: float = 40.0
@export var base_damage: int = 5
@export var attack_cooldown: float = 1.5
@export var reward_money: int = 15 # เงินที่ได้ตอนฆ่าตาย
@export var enemy_scene: PackedScene # Scene ของศัตรูตัวนี้สำหรับ PoolManager
