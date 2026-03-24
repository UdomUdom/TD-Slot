extends Control
# res://ui/hud/hud.gd

@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	# รอฟังเสียงประกาศจาก SignalBus ว่าเงินเปลี่ยนไปเท่าไหร่
	SignalBus.money_changed.connect(_on_money_changed)

func _on_money_changed(current_amount: int) -> void:
	# อัปเดตข้อความบนจอ
	money_label.text = "Money: " + str(current_amount)
