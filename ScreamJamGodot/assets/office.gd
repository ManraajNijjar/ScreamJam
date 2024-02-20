extends Node3D

signal toTrainPM

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.connect("dialogue_ended", dialogueEndedFunction)
	DialogueManager.connect("got_dialogue", receivedDialogueFunction)
	DialogueManager.connect("passed_title", passedTitleFunction)

	toTrainPM.connect(goToTrainPM);

	if(PlayerVariables.day == 0):
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_office")
	
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
	if value == "toTrainPM":
		get_tree().change_scene_to_file("res://assets/subway.tscn")
		pass
	pass

func goToTrainPM():
	get_tree().change_scene_to_file("res://assets/subway.tscn")
	pass