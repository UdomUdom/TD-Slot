extends Area2D
class_name BaseStructure
# res://scenes/entities/actors/base_structure.gd

@export var is_player_base: bool = true
@export var max_health: int = 1000
@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		health_component.initialize(max_health)
		health_component.died.connect(_on_died)

	# กำหนด Group ให้ถูกต้อง (ฐานเรา = units, ฐานศัตรู = enemies)
	var group_name = "units" if is_player_base else "enemies"
	add_to_group(group_name)

	# รอให้ LaneManager โหลดข้อมูลเลนเสร็จก่อน แล้วค่อยฝังตัวลงไปในทุกเลน
	call_deferred("_register_to_all_lanes")

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
