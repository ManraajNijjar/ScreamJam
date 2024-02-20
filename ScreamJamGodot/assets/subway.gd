extends Node3D

signal toOffice
signal toHousePM

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.connect("dialogue_ended", dialogueEndedFunction)
	DialogueManager.connect("got_dialogue", receivedDialogueFunction)
	DialogueManager.connect("passed_title", passedTitleFunction)

	toOffice.connect(goToOffice);
	toHousePM.connect(goToHousePM);

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_pm")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dialogueEndedFunction(value):
	pass;

func receivedDialogueFunction(value):
	pass;

func passedTitleFunction(value):
	pass;

func goToOffice():
	get_tree().change_scene_to_file("res://assets/office.tscn")
	pass

func goToHousePM():
	get_tree().change_scene_to_file("res://assets/home.tscn")
	pass