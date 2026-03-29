extends Area2D
class_name BaseStructure

@export var is_player_base: bool = true
@export var max_health: int = 1000
@export var health_component: HealthComponent

@onready var health_bar: ProgressBar = $ProgressBar 

@export var hitbox_radius: float = 100.0

func _ready() -> void:
	if health_component:
		health_component.initialize(max_health)
		health_component.died.connect(_on_died)
		
		# --- เชื่อมสัญญาณหลอดเลือด ---
		health_component.health_changed.connect(_on_health_changed)
		
		# ตั้งค่าเริ่มต้นให้หลอดเลือด
		health_bar.max_value = max_health
		health_bar.value = max_health

	var group_name = "units" if is_player_base else "enemies"
	add_to_group(group_name)
	call_deferred("_register_to_all_lanes")

# --- ฟังก์ชันอัปเดตหลอดเลือด ---
func _on_health_changed(current: int, max_hp: int) -> void:
	health_bar.max_value = max_hp
	health_bar.value = current

func _register_to_all_lanes() -> void:
	var group_name = "units" if is_player_base else "enemies"
	# นำฐานทัพนี้ไปลงทะเบียนไว้ในทุกๆ เลนที่มีในด่าน
	for lane_id in LaneManager.active_lanes.keys():
		LaneManager.register_entity(self, lane_id, group_name)

func take_damage(amount: int) -> void:
	if health_component:
		health_component.take_damage(amount)
		# ส่งสัญญาณไปบอก UI ว่าฐานโดนตี (เผื่อทำจอแดงสั่น หรือลดหลอดเลือด)
		SignalBus.base_damaged.emit(amount, is_player_base)

func _on_died() -> void:
	var group_name = "units" if is_player_base else "enemies"
	
	# ถอนตัวออกจากทุกเลน
	for lane_id in LaneManager.active_lanes.keys():
		LaneManager.unregister_entity(self, lane_id, group_name)
		
	# ส่งสัญญาณจบเกม (ถ้าฐานเราพัง แปลว่าแพ้ (win = false))
	SignalBus.game_over.emit(not is_player_base)
	
	queue_free() # ทำลายฐานทิ้ง
