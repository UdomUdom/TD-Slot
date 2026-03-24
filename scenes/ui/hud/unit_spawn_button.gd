extends Button
# res://ui/hud/unit_spawn_button.gd

@export var unit_to_spawn: Resource 
@export var target_lane: int = 0    

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	SignalBus.money_changed.connect(_on_money_changed)
	
	# ตั้งชื่อปุ่มและราคาเริ่มต้น
	if unit_to_spawn:
		text = "%s ($%d)" % [unit_to_spawn.display_name, unit_to_spawn.cost]

func _on_button_pressed() -> void:
	if unit_to_spawn:
		SignalBus.unit_spawn_requested.emit(unit_to_spawn, target_lane)

# ฟังก์ชันนี้จะถูกเรียกทุกครั้งที่เงินในเกมเปลี่ยน
func _on_money_changed(current_money: int) -> void:
	if unit_to_spawn:
		# ถ้าเงินน้อยกว่า cost ให้ปรับปุ่มเป็น Disabled (กดไม่ได้)
		disabled = current_money < unit_to_spawn.cost
