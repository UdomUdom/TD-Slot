extends Control

@export var all_levels: Array[LevelData]

@onready var levels_grid: GridContainer = $VBoxContainer/ScrollContainer/GridContainer
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_populate_levels()

func _populate_levels() -> void:
	for child in levels_grid.get_children():
		child.queue_free()
		
	for level in all_levels:
		if level == null: continue
		
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(300, 200)
		btn.text = "%s\n(Lanes: %d)" % [level.level_name, level.lanes.size()]
		btn.pressed.connect(_on_level_selected.bind(level))
		levels_grid.add_child(btn)

func _on_level_selected(level: LevelData) -> void:
	GameSession.selected_level = level
	# After selecting level, go to unit selection
	get_tree().change_scene_to_file("res://scenes/ui/menus/unit_selection_screen.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
