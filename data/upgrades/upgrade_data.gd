extends Resource
class_name UpgradeData
# res://data/upgrades/upgrade_data.gd

@export var id: String = "atk_up_1"
@export var display_name: String = "Attack +10"
@export var description: String = "เพิ่มพลังโจมตีให้ทหารทุกตัว 10 หน่วย"
@export var icon: Texture2D # เผื่อใส่รูปในหน้า UI

@export_group("Modifier Settings")
# ระบุชื่อตัวแปรที่อยากปรับ เช่น "base_damage", "max_health", "move_speed", "attack_cooldown"
@export var stat_to_modify: String = "base_damage" 

# ค่าที่จะบวกเพิ่มเข้าไปตรงๆ (เช่น +10)
@export var add_value: float = 0.0 

# ค่าที่จะคูณเพิ่ม (ใส่ 0.1 แปลว่าบวก 10%, ใส่ -0.2 แปลว่าลด 20% ซึ่งเหมาะกับพวกลดคูลดาวน์)
@export var multiply_bonus: float = 0.0
