extends Resource
class_name LaneData
# res://data/lanes/lane_data.gd

@export var lane_id: int = 0
@export var y_position: float = 0.0

enum LaneType { GROUND, WATER, AIR }
@export var type: LaneType = LaneType.GROUND

@export var is_blocked: bool = false
