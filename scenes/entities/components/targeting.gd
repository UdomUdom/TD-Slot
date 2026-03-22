extends Node
class_name TargetingComponent

@export var actor: Node2D
var attack_range: float = 100.0
var current_lane_id: int
var current_target: Node2D = null

func setup(lane_id: int, range_val: float) -> void:
	current_lane_id = lane_id
	attack_range = range_val

func get_target() -> Node2D:
	# 1. เช็คว่าเป้าหมายเดิมยังอยู่และยังอยู่ในระยะหรือไม่
	if is_instance_valid(current_target):
		var dist = actor.global_position.distance_to(current_target.global_position)
		if dist <= attack_range:
			return current_target # ตีตัวเดิมต่อไป
			
	# 2. ถ้าเป้าหมายเดิมตาย หรือไม่อยู่ในระยะ ให้หาตัวใหม่ที่ใกล้ที่สุดในเลน
	var potential_target = LaneManager.get_closest_enemy(current_lane_id, actor.global_position)
	
	if potential_target:
		var dist = actor.global_position.distance_to(potential_target.global_position)
		if dist <= attack_range:
			current_target = potential_target
			return current_target
			
	# 3. ไม่มีศัตรูในระยะเลย
	current_target = null
	return null
