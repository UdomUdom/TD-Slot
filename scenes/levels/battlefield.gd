extends Node2D
# res://scenes/levels/battlefield.gd

#@export var level_lanes: Array[LaneData]
#@export var level_waves: Array[WaveData] # <-- เพิ่มบรรทัดนี้ เพื่อรับค่า Wave จาก Inspector
#
#@onready var units_container: Node2D = $Entities/Units
#@onready var enemies_container: Node2D = $Entities/Enemies
#
#func _ready() -> void:
	#if level_lanes.size() > 0:
		#LaneManager.setup_lanes(level_lanes)
	#
	#GameManager.unit_container = units_container
	#GameManager.projectile_container = $Entities/Projectiles/BaseProjectile
	#
	## ผูกโฟลเดอร์ศัตรูเข้ากับ WaveManager
	#WaveManager.enemy_container = enemies_container # <-- เพิ่มบรรทัดนี้
	#
	#SignalBus.game_started.emit()
	#
	## เริ่มปล่อย Wave ทันทีที่เริ่มเกม!
	#if level_waves.size() > 0:
		#WaveManager.start_level_waves(level_waves) # <-- เพิ่มบรรทัดนี้
	#else:
		#push_warning("Battlefield: ยังไม่ได้ใส่ข้อมูล WaveData!")
	#SignalBus.game_over.connect(_on_game_over)
#
#func _on_game_over(win: bool) -> void:
	## ในอนาคตเราจะเรียกใช้ UI หน้าต่างสรุปผลตรงนี้
	#if win:
		#print("VICTORY! Enemy Base Destroyed!")
		## ตัวอย่างการหยุดเกม: get_tree().paused = true
	#else:
		#print("DEFEAT! Player Base Destroyed!")
		## ตัวอย่างการหยุดเกม: get_tree().paused = true
## ฟังก์ชันนี้เตรียมไว้เผื่อคุณพร้อมทำ PoolManager เต็มรูปแบบ
## func _setup_pools() -> void:
	## PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_unit.tscn"), "soldier_unit", 20)
	## PoolManager.initialize_pool(preload("res://scenes/entities/actors/base_enemy.tscn"), "basic_enemy", 30)

@export var level_lanes: Array[LaneData]
@export var level_waves: Array[WaveData] 

# --- เพิ่มตัวแปรอ้างอิงถึงฐานทัพในฉาก ---
@export var player_base: BaseStructure
@export var enemy_base: BaseStructure

@onready var units_container: Node2D = $Entities/Units
@onready var enemies_container: Node2D = $Entities/Enemies

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
	
	SignalBus.game_started.emit() 
	
	if level_waves.size() > 0:
		WaveManager.start_level_waves(level_waves) 
	else:
		push_warning("Battlefield: ยังไม่ได้ใส่ข้อมูล WaveData!")
	SignalBus.game_over.connect(_on_game_over)

func _on_game_over(win: bool) -> void:
	if win:
		print("VICTORY! Enemy Base Destroyed!")
	else:
		print("DEFEAT! Player Base Destroyed!")
