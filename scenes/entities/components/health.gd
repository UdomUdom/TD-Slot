extends Node
class_name HealthComponent
# res://entities/components/health.gd

signal died
signal health_changed(current: int, max_hp: int)

@export var max_health: int = 100
var current_health: int

func initialize(hp: int) -> void:
	max_health = hp
	current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return # ตายไปแล้ว
		
	current_health -= amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	if current_health > 0:
		current_health = min(current_health + amount, max_health)
		health_changed.emit(current_health, max_health)
