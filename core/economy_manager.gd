extends Node
# res://core/economy_manager.gd

var current_money: int = 100

func _ready() -> void:
	# เมื่อมีศัตรูตายที่ไหนดังขึ้นมาใน SignalBus เราจะเอาเงินเข้ากระเป๋า
	SignalBus.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(_enemy_id: String, reward: int, _lane_id: int) -> void:
	add_money(reward)

func add_money(amount: int) -> void:
	current_money += amount
	SignalBus.money_changed.emit(current_money)

# คืนค่า true ถ้ามีเงินพอและจ่ายสำเร็จ
func spend_money(amount: int) -> bool:
	if current_money >= amount:
		current_money -= amount
		SignalBus.money_changed.emit(current_money)
		return true
	return false
