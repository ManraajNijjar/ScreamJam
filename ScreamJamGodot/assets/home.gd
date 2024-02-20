extends Node3D

@export var player : Node3D;

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.connect("dialogue_ended", dialogueEndedFunction)
	DialogueManager.connect("got_dialogue", receivedDialogueFunction)
	DialogueManager.connect("passed_title", passedTitleFunction)

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dialogueEndedFunction(value):
	#print(value);
	pass

func receivedDialogueFunction(value):
	#print(value);
	pass

func passedTitleFunction(value):
	print(value);
	if value == "showCoffee":
		pass
	if value == "toTrainAM":
		get_tree().change_scene_to_file("res://assets/subway.tscn")
		pass
	if value == "showCall":
		player.displayCall();
		pass
	if value == "toHouseAM":
		pass
	pass
