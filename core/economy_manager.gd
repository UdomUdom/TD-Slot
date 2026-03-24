extends Node
# res://core/economy_manager.gd

var current_money: int = 999999

# --- Passive Income Settings ---
var passive_income_amount: int = 5  # ได้เงิน 5 บาท
var income_interval: float = 1.0    # ทุกๆ 1 วินาที
var _timer: float = 0.0

func _ready() -> void:
	SignalBus.enemy_died.connect(_on_enemy_died)
	
	# ส่งค่าเริ่มต้นไปให้ UI แสดงผลตอนเริ่มเกม
	call_deferred("_update_ui")

func _process(delta: float) -> void:
	# ระบบนับเวลาแจกเงินอัตโนมัติ
	_timer += delta
	if _timer >= income_interval:
		_timer -= income_interval
		add_money(passive_income_amount)

func _on_enemy_died(_enemy_id: String, reward: int, _lane_id: int) -> void:
	add_money(reward)

func add_money(amount: int) -> void:
	current_money += amount
	_update_ui()

# คืนค่า true ถ้ามีเงินพอและจ่ายสำเร็จ
func spend_money(amount: int) -> bool:
	if current_money >= amount:
		current_money -= amount
		_update_ui()
		return true
	return false

func _update_ui() -> void:
	SignalBus.money_changed.emit(current_money)
