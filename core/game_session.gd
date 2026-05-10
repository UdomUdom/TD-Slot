extends Node
# res://core/game_session.gd

const MAX_UNITS = 6

# This will hold the up to 6 UnitData resources the player selected
var selected_mission_units: Array[UnitData] = []

# Current level being played
var selected_level: LevelData = null

# (Optional) List of all units the player has unlocked
var unlocked_units: Array[UnitData] = []
