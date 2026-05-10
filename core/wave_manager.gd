extends Node
# res://core/wave_manager.gd

var current_wave_index: int = 0
var waves: Array[WaveData] = []
var is_wave_active: bool = false
var enemies_spawned_this_wave: int = 0
var enemies_killed_this_wave: int = 0 # <--- 1. เพิ่มตัวแปรนับศัตรูที่ตาย
var _spawn_timer: float = 0.0

var enemy_container: Node2D 
var enemy_spawn_x: float = 1200.0 

func _ready() -> void:
	# 2. แอบฟังว่ามีศัตรูตายเมื่อไหร่ เพื่อนำมานับยอด
	SignalBus.enemy_died.connect(_on_enemy_died)

func start_level_waves(level_waves: Array[WaveData]) -> void:
	waves = level_waves
	current_wave_index = 0
	_start_current_wave()

func _start_current_wave() -> void:
	if current_wave_index >= waves.size():
		# ถ้าเล่นครบทุกเวฟแล้ว ส่งสัญญาณบอกว่าชนะเกม!
		SignalBus.game_over.emit(true) 
		return

	is_wave_active = true
	enemies_spawned_this_wave = 0
	enemies_killed_this_wave = 0 # <--- รีเซ็ตค่าตอนเริ่มเวฟใหม่
	_spawn_timer = 0.0
	
	var wave_num = waves[current_wave_index].wave_number
	SignalBus.wave_started.emit(wave_num)
	print("--- Wave %d Started! ---" % wave_num)

func _process(delta: float) -> void:
	if not is_wave_active or waves.is_empty():
		return

	var current_wave = waves[current_wave_index]

	# 3. นับเวลาถอยหลังเพื่อเสกศัตรู (ทำเฉพาะตอนที่ยังเสกไม่ครบโควต้า)
	if enemies_spawned_this_wave < current_wave.total_enemies:
		_spawn_timer += delta
		if _spawn_timer >= current_wave.time_between_spawns:
			_spawn_timer -= current_wave.time_between_spawns
			_spawn_random_enemy(current_wave)

func _spawn_random_enemy(wave: WaveData) -> void:
	if wave.allowed_enemies.is_empty() or not is_instance_valid(enemy_container):
		return

	var random_enemy_data = wave.allowed_enemies.pick_random()
	
	var available_lanes = LaneManager.active_lanes.keys()
	if available_lanes.is_empty(): return
	var random_lane = available_lanes.pick_random()

	_spawn_enemy(random_enemy_data, random_lane)

	enemies_spawned_this_wave += 1

func _spawn_enemy(enemy_data: EnemyData, lane_id: int) -> void:
	var lane_y_pos = LaneManager.active_lanes[lane_id]["data"].y_position
	
	# สุ่มค่า
	var random_y_offset = randf_range(-5.0, 5.0)
	var final_y_pos = lane_y_pos + random_y_offset
	
	var spawn_pos = Vector2(enemy_spawn_x, final_y_pos)

	var enemy_instance = PoolManager.get_instance(enemy_data.enemy_scene, enemy_data.id)
	enemy_container.add_child(enemy_instance)
	enemy_instance.setup(enemy_data, lane_id, spawn_pos)

# 4. ฟังก์ชันใหม่เช็คสถานะตอนศัตรูตาย
func _on_enemy_died(_enemy_id: String, _reward: int, _lane_id: int, _killer: Node2D = null) -> void:
	if not is_wave_active: return
		
	enemies_killed_this_wave += 1
	
	var current_wave = waves[current_wave_index]
	
	# ถ้าศัตรูเกิดครบแล้ว และ ตายครบแล้ว ค่อยประกาศจบเวฟ
	if enemies_spawned_this_wave >= current_wave.total_enemies and enemies_killed_this_wave >= current_wave.total_enemies:
		_end_current_wave()

func _end_current_wave() -> void:
	is_wave_active = false
	var wave_num = waves[current_wave_index].wave_number
	SignalBus.wave_cleared.emit(wave_num)
	print("--- Wave %d Cleared! Next wave in 5 seconds... ---" % wave_num)
	
	current_wave_index += 1
	
	get_tree().create_timer(5.0).timeout.connect(_start_current_wave)
