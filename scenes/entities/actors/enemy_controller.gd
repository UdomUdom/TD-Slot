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
var hitbox_radius: float = 5.0

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_health_depleted)

func setup(data: EnemyData, lane_id: int, spawn_pos: Vector2) -> void:
	enemy_data = data
	current_lane_id = lane_id
	global_position = spawn_pos
	add_to_group("enemies")
	
	_initialize_components()
	
	# ข้อแตกต่างที่ 1: ลงทะเบียนเป็น "enemies"
	LaneManager.register_entity(self, current_lane_id, "enemies")

func _initialize_components() -> void:
	if visuals is AnimatedSprite2D or visuals is Sprite2D:
		visuals.flip_h = true
		
	if visuals is AnimatedSprite2D and enemy_data.get("animation_set") != null:
		visuals.sprite_frames = enemy_data.animation_set
	
	if health_component:
		health_component.initialize(enemy_data.max_health)
	if movement_component:
		movement_component.speed = enemy_data.move_speed
		# ข้อแตกต่างที่ 2: ศัตรูเดินไปทางซ้าย (-1)
		movement_component.direction = -1 
		movement_component.current_lane_id = current_lane_id
		movement_component.resume_movement()
	if targeting_component:
		targeting_component.setup(current_lane_id, enemy_data.attack_range, "units")
		
	if weapon_component:
		# --- เพิ่ม 2 บรรทัดนี้เพื่อให้ศัตรูรู้จักการยิงปืน ---
		weapon_component.is_ranged = enemy_data.is_ranged
		weapon_component.projectile_data = enemy_data.projectile_data
		# ----------------------------------------
		
		weapon_component.setup(
			enemy_data.base_damage, 
			enemy_data.attack_cooldown, 
			current_lane_id, 
			-1,              
			"units"          
		)

func _process(delta: float) -> void:
	if health_component and health_component.current_health <= 0: return
		
	if targeting_component and weapon_component:
		var target = targeting_component.get_target()

		if target:
			movement_component.stop_movement()

			if visuals is AnimatedSprite2D:
				visuals.play("attack")

			if weapon_component.can_attack():
				weapon_component.attack(target)
		else:
			movement_component.resume_movement()

			if visuals is AnimatedSprite2D:
				visuals.play("walk")

func _on_health_depleted() -> void:
	die()

func die() -> void:
	LaneManager.unregister_entity(self, current_lane_id, "enemies")
	
	# ข้อแตกต่างที่ 3: ส่ง Signal แจกเงินรางวัลเมื่อตาย
	var killer = null
	if health_component:
		killer = health_component.last_attacker
		
	SignalBus.enemy_died.emit(enemy_data.id, enemy_data.reward_money, current_lane_id, killer)
	
	PoolManager.return_instance(self, enemy_data.id)

func take_damage(amount: int, attacker: Node2D = null) -> void:
	if health_component:
		health_component.take_damage(amount, attacker)
