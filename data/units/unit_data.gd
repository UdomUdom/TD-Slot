extends Resource
class_name UnitData
# res://data/units/unit_data.gd

@export var id: String = "soldier"
@export var display_name: String = "Soldier"
@export var cost: int = 50

@export_group("Combat Stats")
@export var max_health: int = 100
@export var move_speed: float = 50.0
@export var attack_range: float = 100.0
@export var base_damage: int = 10
@export var attack_cooldown: float = 1.0

@export_group("Scenes")
@export var unit_scene: PackedScene
