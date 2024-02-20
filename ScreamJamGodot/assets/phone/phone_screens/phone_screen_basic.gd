extends Control

@onready var button1 = $VBoxContainer/GridContainer/Button
@onready var momCallScreen = $MomCallScreen


var filename ="";
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showMomCall():
	momCallScreen.visible = true;
	if PlayerVariables.day == 0:
		filename = "res://narrative/start.dialogue"
	else:
		filename = "res://narrative/day_" + str(PlayerVariables.day+1) + ".dialogue"

func _on_mom_reject_pressed():
	momCallScreen.visible = false;
	DialogueManager.show_example_dialogue_balloon(load(filename), "deny_call_mom")
	pass # Replace with function body.

func _on_mom_pickup_pressed():
	momCallScreen.visible = false;
	DialogueManager.show_example_dialogue_balloon(load(filename), "pick_up_call_mom")
	pass # Replace with function body.
