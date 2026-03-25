extends Node
# res://core/lane_manager.gd

# Dictionary to store active lanes.
# Key: lane_id (int)
# Value: Dictionary containing "data", "units", "enemies", and "projectiles" Arrays.
var active_lanes: Dictionary = {}

# Called by the Level/Battlefield when a stage starts
func setup_lanes(lanes_data: Array[LaneData]) -> void:
	active_lanes.clear()
	for lane in lanes_data:
		active_lanes[lane.lane_id] = {
			"data": lane,
			"units": [],
			"enemies": [],
			"projectiles": []
		}

# Entities call this when they enter the scene
func register_entity(entity: Node2D, lane_id: int, entity_group: String) -> void:
	if not active_lanes.has(lane_id):
		push_warning("LaneManager: Trying to register entity to non-existent lane %d" % lane_id)
		return
	
	# entity_group should be "units", "enemies", or "projectiles"
	if entity_group in active_lanes[lane_id]:
		active_lanes[lane_id][entity_group].append(entity)

# Entities call this when they die or are returned to the pool
func unregister_entity(entity: Node2D, lane_id: int, entity_group: String) -> void:
	if active_lanes.has(lane_id) and entity_group in active_lanes[lane_id]:
		active_lanes[lane_id][entity_group].erase(entity)

# --- Helper Functions for Combat (Auto-targeting) ---

func get_enemies_in_lane(lane_id: int) -> Array:
	if active_lanes.has(lane_id):
		return active_lanes[lane_id]["enemies"]
	return []

# Useful for "Tall Units" or "Global Attackers" that hit multiple lanes
func get_enemies_in_lanes(lane_ids: Array[int]) -> Array:
	var target_enemies = []
	for lane_id in lane_ids:
		target_enemies.append_array(get_enemies_in_lane(lane_id))
	return target_enemies
	
# ฟังก์ชันใหม่ที่ฉลาดขึ้น หาได้ทั้งฝั่ง "units" และ "enemies"
func get_closest_entity(lane_id: int, global_pos: Vector2, target_group: String) -> Node2D:
	if not active_lanes.has(lane_id) or not active_lanes[lane_id].has(target_group):
		return null
		
	var entities = active_lanes[lane_id][target_group]
	if entities.is_empty():
		return null
		
	var closest_entity: Node2D = null
	var min_distance := INF
	
	for entity in entities:
		if is_instance_valid(entity) and entity.health_component.current_health > 0:
			var dist = global_pos.distance_squared_to(entity.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_entity = entity
				
	return closest_entity
