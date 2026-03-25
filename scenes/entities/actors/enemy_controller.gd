extends Area2D
class_name EnemyController
# res://entities/actors/enemy_controller.gd

@export var visuals: Node2D
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var targeting_component: TargetingComponent
@export var weapon_component: WeaponComponent

var enemy_data: EnemyData
var current_lane_id: int

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_health_depleted)

func setup(data: EnemyData, lane_id: int, spawn_pos: Vector2) -> void:
	enemy_data = data
	current_lane_id = lane_id
	global_position = spawn_pos
	
	_initialize_components()
	
	# ข้อแตกต่างที่ 1: ลงทะเบียนเป็น "enemies"
	LaneManager.register_entity(self, current_lane_id, "enemies")

func _initialize_components() -> void:
	if health_component:
		health_component.initialize(enemy_data.max_health)
	if movement_component:
		movement_component.speed = enemy_data.move_speed
		# ข้อแตกต่างที่ 2: ศัตรูเดินไปทางซ้าย (-1)
		movement_component.direction = -1 
		movement_component.resume_movement()
	if targeting_component:
		targeting_component.setup(current_lane_id, enemy_data.attack_range, "units")
	if weapon_component:
		weapon_component.setup(enemy_data.base_damage, enemy_data.attack_cooldown)

func _process(delta: float) -> void:
	if health_component and health_component.current_health <= 0: return
		
	if targeting_component and weapon_component:
		var target = targeting_component.get_target()
		if target:
			movement_component.stop_movement()
			if weapon_component.can_attack():
				weapon_component.attack(target)
		else:
			movement_component.resume_movement()

func _on_health_depleted() -> void:
	die()

func die() -> void:
	LaneManager.unregister_entity(self, current_lane_id, "enemies")
	
	# ข้อแตกต่างที่ 3: ส่ง Signal แจกเงินรางวัลเมื่อตาย
	SignalBus.enemy_died.emit(enemy_data.id, enemy_data.reward_money, current_lane_id)
	
	PoolManager.return_instance(self, enemy_data.id)

func take_damage(amount: int) -> void:
	if health_component:
		health_component.take_damage(amount)
