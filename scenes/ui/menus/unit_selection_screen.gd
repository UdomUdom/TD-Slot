extends Control
# res://scenes/ui/menus/unit_selection_screen.gd

@export var all_game_units: Array[UnitData] # Drag all your unit .tres files here in the Inspector

@onready var selected_slots_container: HBoxContainer = $VBoxContainer/TopPanel/SelectedSlots
@onready var available_grid: GridContainer = $VBoxContainer/BottomSplit/AvailableRoster/GridContainer

@onready var details_icon: TextureRect = $VBoxContainer/BottomSplit/DetailsPanel/VBox/UnitIcon
@onready var details_name: Label = $VBoxContainer/BottomSplit/DetailsPanel/VBox/UnitName
@onready var details_stats: Label = $VBoxContainer/BottomSplit/DetailsPanel/VBox/UnitStats
@onready var equip_button: Button = $VBoxContainer/BottomSplit/DetailsPanel/VBox/EquipButton
@onready var start_button: Button = $VBoxContainer/StartMissionButton

var currently_viewed_unit: UnitData = null

func _ready() -> void:
	# 1. Populate the available units grid
	_populate_roster()
	
	# 2. Clear the top slots visually
	_update_selected_slots_ui()
	
	equip_button.pressed.connect(_on_equip_pressed)
	start_button.pressed.connect(_on_start_mission_pressed)
	
	# Hide details initially
	details_name.text = "Select a unit"
	details_stats.text = ""
	equip_button.disabled = true

func _populate_roster() -> void:
	# Clear placeholder children if any
	for child in available_grid.get_children():
		child.queue_free()
		
	# Create a button for every available unit
	for unit in all_game_units:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(80, 80)
		btn.text = unit.display_name
		# If you have icons in UnitData: btn.icon = unit.icon
		
		btn.pressed.connect(_on_roster_unit_clicked.bind(unit))
		available_grid.add_child(btn)

func _on_roster_unit_clicked(unit: UnitData) -> void:
	currently_viewed_unit = unit
	
	# Update Details Panel
	details_name.text = unit.display_name
	details_stats.text = "Cost: $%d\nHP: %d\nDMG: %d\nRange: %d" % [
		unit.cost, unit.max_health, unit.base_damage, unit.attack_range
	]
	
	equip_button.disabled = false
	
	# Change button text depending on if it's already equipped
	if GameSession.selected_mission_units.has(unit):
		equip_button.text = "Unequip"
	else:
		equip_button.text = "Equip"

func _on_equip_pressed() -> void:
	if currently_viewed_unit == null: return
	
	var is_equipped = GameSession.selected_mission_units.has(currently_viewed_unit)
	
	if is_equipped:
		# Remove it
		GameSession.selected_mission_units.erase(currently_viewed_unit)
		equip_button.text = "Equip"
	else:
		# Add it (if we have space)
		if GameSession.selected_mission_units.size() < GameSession.MAX_UNITS:
			GameSession.selected_mission_units.append(currently_viewed_unit)
			equip_button.text = "Unequip"
		else:
			print("Roster Full! Max 6 units.")
			
	_update_selected_slots_ui()

func _update_selected_slots_ui() -> void:
	var slots = selected_slots_container.get_children()
	
	for i in range(slots.size()):
		var slot_ui = slots[i] # Assuming these are Buttons or Labels
		
		if i < GameSession.selected_mission_units.size():
			var unit = GameSession.selected_mission_units[i]
			slot_ui.text = unit.display_name
			# slot_ui.icon = unit.icon
		else:
			slot_ui.text = "Empty"
			# slot_ui.icon = null

func _on_start_mission_pressed() -> void:
	if GameSession.selected_mission_units.is_empty():
		print("Please select at least 1 unit!")
		return
		
	# Transition to the battlefield!
	get_tree().change_scene_to_file("res://scenes/levels/battlefield.tscn")
