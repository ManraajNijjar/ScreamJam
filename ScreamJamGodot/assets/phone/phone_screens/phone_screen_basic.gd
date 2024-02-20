extends Control

@onready var button1 = $VBoxContainer/GridContainer/Button
@onready var momCallScreen = $MomCallScreen

signal displayMomCall

# Called when the node enters the scene tree for the first time.
func _ready():
	displayMomCall.connect(toggleMomCall);
	pass # Replace with function body.

func toggleMomCall(dayCall):
	momCallScreen.visible = true;

func _on_button_pressed():
	print("Button 1 was pressed")
	#DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_am")
	pass # Replace with function body.

func _on_button_focus_entered():
	print("Button 1 has focus")
	pass # Replace with function body.
