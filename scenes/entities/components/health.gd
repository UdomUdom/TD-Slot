extends Node
class_name HealthComponent
# res://entities/components/health.gd

signal died
signal health_changed(current: int, max_hp: int)
signal shield_changed(current: int, max_shield: int)

@export var max_health: int = 100
var current_health: int

var max_shield: int = 0
var current_shield: int = 0

var last_attacker: Node2D = null

func initialize(hp: int) -> void:
	max_health = hp
	current_health = max_health
	health_changed.emit(current_health, max_health)

func add_shield(amount: int) -> void:
	max_shield = amount
	current_shield = amount
	shield_changed.emit(current_shield, max_shield)

func take_damage(amount: int, attacker: Node2D = null) -> void:
	if current_health <= 0:
		return # ตายไปแล้ว
	
	last_attacker = attacker
	
	if current_shield > 0:
		var shield_damage = min(amount, current_shield)
		current_shield -= shield_damage
		amount -= shield_damage
		shield_changed.emit(current_shield, max_shield)
		
		# Kinetic Absorption: Damage to shield generates Chaos
		if shield_damage > 0:
			SignalBus.projectile_blocked.emit() 
			
		if amount <= 0:
			return
		
	current_health -= amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	if current_health > 0:
		current_health = min(current_health + amount, max_health)
		health_changed.emit(current_health, max_health)
