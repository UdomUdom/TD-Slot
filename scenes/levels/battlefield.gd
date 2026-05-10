extends Node2D

@export var level_data: LevelData

# --- เพิ่มตัวแปรอ้างอิงถึงฐานทัพในฉาก ---
@export var player_base: BaseStructure
@export var enemy_base: BaseStructure

@onready var units_container: Node2D = $Entities/Units
@onready var enemies_container: Node2D = $Entities/Enemies

func _ready() -> void:
	if not level_data:
		push_error("Battlefield: No level_data assigned!")
		return

	if level_data.lanes.size() > 0:
		LaneManager.setup_lanes(level_data.lanes)
	
	GameManager.unit_container = units_container
	WaveManager.enemy_container = enemies_container 
	GameManager.projectile_container = $Entities/Projectiles
	
	# --- คำนวณจุดเกิดให้อยู่หน้าฐานทัพ ---
	if player_base:
		GameManager.player_spawn_x = player_base.global_position.x + 100.0
		
	if enemy_base:
		WaveManager.enemy_spawn_x = enemy_base.global_position.x - 100.0

	# ส่งข้อมูลรางวัลไปให้ตู้สล็อต
	if level_data.slot_rewards.size() > 0:
		SlotMachineManager.setup_rewards(level_data.slot_rewards)
	
	SignalBus.game_started.emit() 
	
	if level_data.waves.size() > 0:
		WaveManager.start_level_waves(level_data.waves) 
	
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.wave_cleared.connect(_on_wave_cleared)

# ฟังก์ชันใหม่! ถูกเรียกเมื่อศัตรูหมดเวฟ
func _on_wave_cleared(_wave_num: int) -> void:
	if level_data.upgrades.size() >= 3:
		SignalBus.upgrade_screen_requested.emit(level_data.upgrades)

func _on_game_over(win: bool) -> void:
	if win:
		print("VICTORY! Enemy Base Destroyed!")
	else:
		print("DEFEAT! Player Base Destroyed!")
		
	# สั่งหยุดเวลา แช่แข็งทุกอย่างในเกมทันที!
	get_tree().paused = true
		
## ฟังก์ชันนี้เตรียมไว้เผื่อคุณพร้อมทำ PoolManager เต็มรูปแบบ
## func _setup_pools() -> void:
	## PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_unit.tscn"), "soldier_unit", 20)
	## PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_enemy.tscn"), "basic_enemy", 30)
