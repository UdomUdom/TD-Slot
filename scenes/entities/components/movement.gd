extends Node
class_name MovementComponent
# res://entities/components/movement.gd

# Reference ไปที่ตัว Actor หลัก
@export var actor: Node2D
@export var speed: float = 50.0

var current_lane_id: int = -1

# ทิศทางการเดิน 1 = ขวา (Player), -1 = ซ้าย (Enemy)
var direction: int = 1
var can_move: bool = true

func _physics_process(delta: float) -> void:
	if can_move and actor:
		var modifier = 1.0
		if LaneManager.lane_modifiers.has(current_lane_id):
			modifier = LaneManager.lane_modifiers[current_lane_id]["speed"]
			
		actor.global_position.x += speed * modifier * direction * delta

func stop_movement() -> void:
	can_move = false

func resume_movement() -> void:
	can_move = true
