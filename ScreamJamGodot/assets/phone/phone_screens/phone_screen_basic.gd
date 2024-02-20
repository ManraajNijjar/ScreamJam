extends Control

@onready var button1 = $VBoxContainer/GridContainer/Button
@onready var momCallScreen = $MomCallScreen
#var momChatScreen = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showMomCall():
	momCallScreen.visible = true;

func _on_mom_reject_pressed():
	momCallScreen.visible = false;
	if PlayerVariables.currentCall == 0:
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "deny_call_mom")
	pass # Replace with function body.

func _on_mom_pickup_pressed():
	momCallScreen.visible = false;
	if PlayerVariables.currentCall == 0:
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "pick_up_call_mom")
	pass # Replace with function body.
