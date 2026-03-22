extends Node
class_name WeaponComponent

signal attacked # ส่งบอก Controller เผื่อเล่น Animation โจมตี

var damage: int = 10
var attack_cooldown: float = 1.0
var _cooldown_timer: float = 0.0

func setup(dmg: int, cooldown: float) -> void:
	damage = dmg
	attack_cooldown = cooldown
	_cooldown_timer = 0.0

func _process(delta: float) -> void:
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

func can_attack() -> bool:
	return _cooldown_timer <= 0.0

func attack(target: Node2D) -> void:
	if not can_attack(): 
		return
		
	_cooldown_timer = attack_cooldown
	attacked.emit()
	
	# ส่ง Damage ไปให้เป้าหมาย
	if target.has_method("take_damage"):
		target.take_damage(damage)
