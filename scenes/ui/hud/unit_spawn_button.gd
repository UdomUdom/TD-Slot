extends Button
# res://ui/hud/unit_spawn_button.gd

@export var unit_to_spawn: Resource # ลากไฟล์ UnitData (.tres) มาใส่ตรงนี้
@export var target_lane: int = 0    # ระบุว่าจะให้ลงเลนไหน (0, 1, 2)

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if unit_to_spawn:
		# แค่ตะโกนบอก SignalBus เดี๋ยว GameManager จัดการต่อเอง
		SignalBus.unit_spawn_requested.emit(unit_to_spawn, target_lane)
