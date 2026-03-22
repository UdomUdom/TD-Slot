extends Node
class_name MovementComponent
# res://entities/components/movement.gd

# Reference ไปที่ตัว Actor หลัก
@export var actor: Node2D
@export var speed: float = 50.0

# ทิศทางการเดิน 1 = ขวา (Player), -1 = ซ้าย (Enemy)
var direction: int = 1
var can_move: bool = true

func _physics_process(delta: float) -> void:
	if can_move and actor:
		actor.global_position.x += speed * direction * delta

func stop_movement() -> void:
	can_move = false

func resume_movement() -> void:
	can_move = true
