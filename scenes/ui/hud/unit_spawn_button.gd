extends Button
# res://ui/hud/unit_spawn_button.gd

@export var unit_to_spawn: Resource 
@export var target_lane: int = 0    

var _cooldown_timer: float = 0.0
var _is_on_cooldown: bool = false
var _current_money: int = 0

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	SignalBus.money_changed.connect(_on_money_changed)
	
	if unit_to_spawn:
		_update_button_text()

# --- ระบบนับเวลาถอยหลัง ---
func _process(delta: float) -> void:
	if _is_on_cooldown:
		_cooldown_timer -= delta
		_update_button_text() # อัปเดตตัวเลขบนปุ่ม
		
		# ถ้าเวลาหมดแล้ว
		if _cooldown_timer <= 0.0:
			_is_on_cooldown = false
			_update_button_state()
			_update_button_text()

func _on_button_pressed() -> void:
	# ถ้าไม่ได้ติดคูลดาวน์ และมีข้อมูลยูนิต
	if unit_to_spawn and not _is_on_cooldown:
		SignalBus.unit_spawn_requested.emit(unit_to_spawn, target_lane)
		
		# เริ่มจับเวลา Cooldown ทันทีที่กด
		_is_on_cooldown = true
		_cooldown_timer = unit_to_spawn.spawn_cooldown 
		_update_button_state()

func _on_money_changed(current_money: int) -> void:
	_current_money = current_money
	_update_button_state()

# --- แยกฟังก์ชันเช็คสถานะปุ่ม ---
func _update_button_state() -> void:
	if not unit_to_spawn: return
	
	# ปุ่มจะกดไม่ได้ (Disabled) ถ้าเงินไม่พอ "หรือ" ติดคูลดาวน์อยู่
	disabled = (_current_money < unit_to_spawn.cost) or _is_on_cooldown

# --- แยกฟังก์ชันอัปเดตข้อความบนปุ่ม ---
func _update_button_text() -> void:
	if not unit_to_spawn: return
	
	if _is_on_cooldown:
		# แสดงเวลานับถอยหลัง ทศนิยม 1 ตำแหน่ง เช่น "Soldier (1.5s)"
		text = "%s (%.1fs)" % [unit_to_spawn.display_name, _cooldown_timer]
	else:
		# ถ้าพร้อมกด ให้แสดงราคา
		text = "%s ($%d)" % [unit_to_spawn.display_name, unit_to_spawn.cost]
