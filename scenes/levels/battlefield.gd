extends Node2D
@export var level_lanes: Array[LaneData]
@export var level_waves: Array[WaveData] 

# --- เพิ่มตัวแปรอ้างอิงถึงฐานทัพในฉาก ---
@export var player_base: BaseStructure
@export var enemy_base: BaseStructure

@onready var units_container: Node2D = $Entities/Units
@onready var enemies_container: Node2D = $Entities/Enemies

@export var slot_rewards: Array[SlotRewardData]
@export var level_upgrades: Array[UpgradeData]

func _ready() -> void:
	if level_lanes.size() > 0:
		LaneManager.setup_lanes(level_lanes)
	
	GameManager.unit_container = units_container
	WaveManager.enemy_container = enemies_container 
	GameManager.projectile_container = $Entities/Projectiles
	
	
	# --- คำนวณจุดเกิดให้อยู่หน้าฐานทัพ ---
	if player_base:
		# สมมติให้ทหารเกิดห่างจากฐานเราไปทางขวา 100 พิกเซล
		GameManager.player_spawn_x = player_base.global_position.x + 100.0
		
	if enemy_base:
		# สมมติให้ศัตรูเกิดห่างจากฐานศัตรูไปทางซ้าย 100 พิกเซล
		WaveManager.enemy_spawn_x = enemy_base.global_position.x - 100.0
	# ---------------------------------
	# ส่งข้อมูลรางวัลไปให้ตู้สล็อต
	if slot_rewards.size() > 0:
		SlotMachineManager.setup_rewards(slot_rewards)
	else:
		push_warning("Battlefield: ยังไม่ได้ใส่ของรางวัลตู้สล็อต!")
	
	SignalBus.game_started.emit() 
	
	if level_waves.size() > 0:
		WaveManager.start_level_waves(level_waves) 
	else:
		push_warning("Battlefield: ยังไม่ได้ใส่ข้อมูล WaveData!")
	SignalBus.game_over.connect(_on_game_over)
	
	
# รับสัญญาณว่าเคลียร์เวฟแล้ว
	SignalBus.wave_cleared.connect(_on_wave_cleared)

# ฟังก์ชันใหม่! ถูกเรียกเมื่อศัตรูหมดเวฟ
func _on_wave_cleared(_wave_num: int) -> void:
	if level_upgrades.size() >= 3:
		# ส่งกองการ์ดทั้งหมดไปให้ UpgradeScreen ทำการสุ่ม 3 ใบ
		SignalBus.upgrade_screen_requested.emit(level_upgrades)
	else:
		print("Battlefield: ใส่การ์ดอัปเกรดใน Inspector ไม่ครบ 3 ใบ!")

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
