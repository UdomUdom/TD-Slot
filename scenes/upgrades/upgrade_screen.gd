extends CanvasLayer
# res://ui/upgrades/upgrade_screen.gd

@onready var cards: Array[Button] = [
	$HBoxContainer/Card1,
	$HBoxContainer/Card2,
	$HBoxContainer/Card3
]

var current_options: Array[UpgradeData] = []

func _ready() -> void:
	hide() # ซ่อนไว้ก่อนตอนเริ่มเกม
	SignalBus.upgrade_screen_requested.connect(_on_upgrade_requested)
	
	# ผูกปุ่มเข้ากับฟังก์ชัน โดยส่ง Index ไปด้วยว่ากดไพ่ใบไหน (0, 1, 2)
	for i in range(cards.size()):
		cards[i].pressed.connect(_on_card_selected.bind(i))

func _on_upgrade_requested(upgrades_pool: Array[UpgradeData]) -> void:
	if upgrades_pool.size() < 3:
		push_warning("UpgradeScreen: มีการ์ดอัปเกรดในระบบไม่ถึง 3 ใบ!")
		return
		
	# 1. หยุดเกม (ฟิสิกส์และการเดินจะหยุดนิ่ง)
	get_tree().paused = true
	show()
	
	# 2. สุ่มการ์ด 3 ใบแบบไม่ซ้ำกัน
	var pool_copy = upgrades_pool.duplicate()
	pool_copy.shuffle() # สลับไพ่
	current_options = [pool_copy[0], pool_copy[1], pool_copy[2]]
	
	# 3. ใส่ข้อความลงบนปุ่ม
	for i in range(3):
		var data = current_options[i]
		# ใช้ \n เพื่อขึ้นบรรทัดใหม่
		cards[i].text = "%s\n\n%s" % [data.display_name, data.description]

func _on_card_selected(index: int) -> void:
	var selected_data = current_options[index]
	
	# ส่งสัญญาณไปให้ UpgradeManager เก็บข้อมูล
	SignalBus.upgrade_selected.emit(selected_data)
	
	# ซ่อนหน้าจอ และเดินเกมต่อ!
	hide()
	get_tree().paused = false
