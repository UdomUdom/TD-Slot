extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	# Usually we go to unit selection first
	get_tree().change_scene_to_file("res://scenes/ui/menus/unit_selection_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
