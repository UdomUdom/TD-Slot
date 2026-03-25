extends Resource
class_name WaveData
# res://data/waves/wave_data.gd

@export var wave_number: int = 1
@export var time_between_spawns: float = 2.0  # ปล่อยศัตรูทุกๆ 2 วินาที
@export var total_enemies: int = 10           # จำนวนศัตรูทั้งหมดในเวฟนี้
@export var allowed_enemies: Array[EnemyData] # สุ่มปล่อยศัตรูประเภทไหนบ้างในเวฟนี้
