extends Node
class_name TargetingComponent

@export var actor: Node2D
var attack_range: float = 100.0
var current_lane_id: int
var current_target: Node2D = null

var group_to_target: String = "units" # ค่าเริ่มต้น

# เพิ่มพารามิเตอร์ target_group เข้ามา
func setup(lane_id: int, range_val: float, target_group: String) -> void:
	current_lane_id = lane_id
	attack_range = range_val
	group_to_target = target_group

func get_target() -> Node2D:
	if is_instance_valid(current_target) and current_target.health_component.current_health > 0:
		# 1. เช็คว่าเป้าหมายมีตัวแปร hitbox_radius ไหม (ถ้ามีให้ดึงมา ถ้าไม่มีให้เป็น 0)
		var target_size = 0.0
		if current_target.get("hitbox_radius") != null:
			target_size = current_target.hitbox_radius
			
		var dist_x = abs(actor.global_position.x - current_target.global_position.x)
		
		# 2. เอาระยะห่างมาลบด้วยขนาดของเป้าหมาย ทหารจะได้หยุดที่ "ขอบ" 
		if (dist_x - target_size) <= attack_range:
			return current_target
			
	var potential_target = LaneManager.get_closest_entity(current_lane_id, actor.global_position, group_to_target)
	
	if potential_target:
		var target_size = 0.0
		if potential_target.get("hitbox_radius") != null:
			target_size = potential_target.hitbox_radius
			
		var dist_x = abs(actor.global_position.x - potential_target.global_position.x)
		
		if (dist_x - target_size) <= attack_range:
			current_target = potential_target
			return current_target
			
	current_target = null
	return null
