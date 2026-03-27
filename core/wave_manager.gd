extends Node
# res://core/wave_manager.gd

var current_wave_index: int = 0
var waves: Array[WaveData] = []
var is_wave_active: bool = false
var enemies_spawned_this_wave: int = 0
var _spawn_timer: float = 0.0

# ตัวแปรนี้จะถูกเซ็ตค่าจากฉาก Battlefield
var enemy_container: Node2D 
var enemy_spawn_x: float = 1200.0 

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
	_spawn_timer = 0.0
	
	var wave_num = waves[current_wave_index].wave_number
	SignalBus.wave_started.emit(wave_num)
	print("--- Wave %d Started! ---" % wave_num)

func _process(delta: float) -> void:
	if not is_wave_active or waves.is_empty():
		return

	var current_wave = waves[current_wave_index]

	# นับเวลาถอยหลังเพื่อเสกศัตรูตัวต่อไป
	_spawn_timer += delta
	if _spawn_timer >= current_wave.time_between_spawns:
		_spawn_timer -= current_wave.time_between_spawns
		_spawn_random_enemy(current_wave)

func _spawn_random_enemy(wave: WaveData) -> void:
	# -- เพิ่ม Print สแกนหาจุดที่พัง --
	if wave.allowed_enemies.is_empty():
		print("WaveManager ERROR: ไม่มีศัตรูใน allowed_enemies!")
		return
	if not is_instance_valid(enemy_container):
		print("WaveManager ERROR: หา enemy_container ในฉากไม่เจอ!")
		return

	var random_enemy_data = wave.allowed_enemies.pick_random()
	
	if random_enemy_data.enemy_scene == null:
		print("WaveManager ERROR: ลืมใส่ Scene ให้กับศัตรูชื่อ: ", random_enemy_data.id)
		return
	# -----------------------------

	var available_lanes = LaneManager.active_lanes.keys()
	if available_lanes.is_empty(): return
	var random_lane = available_lanes.pick_random()

	_spawn_enemy(random_enemy_data, random_lane)
	
	# เพิ่ม Print ว่าเกิดสำเร็จ
	print("Spawned enemy in lane: ", random_lane)

	enemies_spawned_this_wave += 1
	if enemies_spawned_this_wave >= wave.total_enemies:
		_end_current_wave()

# ###################################################
#func _spawn_enemy(enemy_data: EnemyData, lane_id: int) -> void:
	## หาตำแหน่ง Y ของเลนนั้น
	#var lane_y_pos = LaneManager.active_lanes[lane_id]["data"].y_position
	#
	## กำหนดจุดเกิดศัตรูให้อยู่ริมขวาของจอ (สมมติ X = 1200)
	#var spawn_pos = Vector2(1200, lane_y_pos)
# ###################################################

func _spawn_enemy(enemy_data: EnemyData, lane_id: int) -> void:
	var lane_y_pos = LaneManager.active_lanes[lane_id]["data"].y_position
	
	var spawn_pos = Vector2(enemy_spawn_x, lane_y_pos)

	var enemy_instance = PoolManager.get_instance(enemy_data.enemy_scene, enemy_data.id)
	enemy_container.add_child(enemy_instance)
	enemy_instance.setup(enemy_data, lane_id, spawn_pos)

func _end_current_wave() -> void:
	is_wave_active = false
	var wave_num = waves[current_wave_index].wave_number
	SignalBus.wave_cleared.emit(wave_num)
	print("--- Wave %d Cleared! Next wave in 5 seconds... ---" % wave_num)
	
	current_wave_index += 1
	
	# พัก 5 วินาทีก่อนเริ่มเวฟต่อไป (ใช้ SceneTree Timer แบบง่ายๆ)
	get_tree().create_timer(5.0).timeout.connect(_start_current_wave)
