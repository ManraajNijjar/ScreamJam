extends Control

@onready var button1 = $VBoxContainer/GridContainer/Button
@onready var momCallScreen = $MomCallScreen

@onready var phoneRingtone = $Phone_Ringtone
@onready var phoneAlert = $Phone_Alert

@onready var phoneIcons = $Phonebgicons
@onready var phoneBg = $TextureRect
@onready var photoMom = $MomCallScreen/momPhoto

@onready var denyTimer = $DenyTimer;

var previousSanity = 100;

var filename ="";
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#if Input.is_action_pressed("viewPhone"):
		#phoneRingtone.post_event();
	processSanityChanges();

func processSanityChanges():
	if PlayerVariables.sanity != previousSanity:
		previousSanity = PlayerVariables.sanity;
		if PlayerVariables.sanity <= 55:
			photoMom.texture = load("res://images/Apartment scene assets/familyphoto-darkest.png")
			phoneBg.texture = load("res://images/Misc assets/phonebg-darkest.png")
		elif PlayerVariables.sanity < 80:
			photoMom.texture = load("res://images/Apartment scene assets/familyphoto-darker.png")
			phoneBg.texture = load("res://images/Misc assets/phonebg-darker.png")
		elif PlayerVariables.sanity < 100:
			photoMom.texture = load("res://images/Apartment scene assets/familyphoto-dark.png")
			phoneBg.texture = load("res://images/Misc assets/phonebg-dark.png")

func showMomCall():
	momCallScreen.visible = true;
	phoneIcons.visible = false;
	phoneRingtone.post_event();
	denyTimer.start();
	if PlayerVariables.day == 0:
		filename = "res://narrative/start.dialogue"
	else:
		filename = "res://narrative/day_" + str(PlayerVariables.day+1) + ".dialogue"

func _on_mom_reject_pressed():
	callPressed()
	DialogueManager.show_dialogue_balloon(load(filename), "deny_call_mom")
	pass # Replace with function body.

func _on_mom_pickup_pressed():
	callPressed()
	DialogueManager.show_dialogue_balloon(load(filename), "pick_up_call_mom")
	pass # Replace with function body.

func callPressed():
	denyTimer.stop();
	momCallScreen.visible = false;
	phoneIcons.visible = true;
	phoneRingtone.stop_event();
	phoneAlert.post_event();




func _on_deny_timer_timeout():
	_on_mom_reject_pressed();
	pass # Replace with function body.
