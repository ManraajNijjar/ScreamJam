extends Node3D

@export var player : Node3D;

signal showCoffee
signal toTrainAM
signal showCall
signal toHouseAM

# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.connect("dialogue_ended", dialogueEndedFunction)
	#DialogueManager.connect("got_dialogue", receivedDialogueFunction)
	#DialogueManager.connect("passed_title", passedTitleFunction)

	showCoffee.connect(displayCoffeeScene);
	toTrainAM.connect(goToTrain);
	showCall.connect(displayPlayerCall);
	toHouseAM.connect(goToHouseAM);

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_pm")
	if(PlayerVariables.day == 1):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_2_house_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_2_house_pm")
	
	pass # Replace with function body.

func displayCoffeeScene():
	pass;

func goToTrain():
	get_tree().change_scene_to_file("res://assets/subway.tscn")
	pass;

func displayPlayerCall():
	player.displayCall();
	pass;

func goToHouseAM():
	pass;